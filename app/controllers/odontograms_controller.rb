class OdontogramsController < ApplicationController
  before_action :set_patient
  before_action :set_odontogram, only: [:show, :update_tooth_state, :create_new_version]

  def index
    @odontograms = @patient.odontograms.order(version: :desc)
  end

  def show
    @states_index = @odontogram.tooth_states.index_by { |ts| [ts.tooth_number, ts.face] }
    @tooth_data = build_tooth_data
  end

  def create
    auto_type = @patient.adult? ? "adult" : "child"
    @odontogram = @patient.odontograms.create!(
      odontogram_type: auto_type,
      version: (@patient.odontograms.maximum(:version) || 0) + 1,
      user_id: 1
    )
    redirect_to patient_odontogram_path(@patient, @odontogram), notice: "Nuevo odontograma creado."
  end

  def update_tooth_state
    tooth_number = params[:tooth_number]
    face = params[:face] || "whole"
    new_state = params[:state]

    # "missing", "implant", and "prosthesis" apply to the whole tooth
    if %w[missing implant prosthesis].include?(new_state)
      @odontogram.tooth_states.where(tooth_number: tooth_number).destroy_all
      face = "whole"
    end

    old_state_record = @odontogram.state_for(tooth_number, face: face)
    old_state = old_state_record&.state || "healthy"

    if new_state == old_state
      old_state_record&.destroy
      @odontogram.record_change(
        tooth_number: tooth_number,
        face: face,
        old_state: old_state,
        new_state: "healthy",
        user_id: 1
      )
    else
      ts = @odontogram.tooth_states.find_or_initialize_by(tooth_number: tooth_number, face: face)
      ts.update!(state: new_state)

      @odontogram.record_change(
        tooth_number: tooth_number,
        face: face,
        old_state: old_state,
        new_state: new_state,
        user_id: 1
      )
    end

    respond_to do |format|
      format.json { render json: { success: true } }
      format.html { redirect_to patient_odontogram_path(@patient, @odontogram) }
    end
  end

  def create_new_version
    new_odonto = @odontogram.duplicate_as_new_version(user_id: 1)
    redirect_to patient_odontogram_path(@patient, new_odonto), notice: "Nueva versión creada."
  end

  private

  def set_patient
    @patient = Patient.find(params[:patient_id])
  end

  def set_odontogram
    @odontogram = @patient.odontograms.find(params[:id])
  end

  def build_tooth_data
    data = {}
    @odontogram.teeth_numbers.each do |tn|
      tooth_data = {}
      Odontogram::FACES.each do |face|
        ts = @states_index[[tn, face]]
        if ts
          state_info = Odontogram::STATES[ts.state.to_sym]
          tooth_data[face] = { state: ts.state, color: state_info&.dig(:color) }
        else
          tooth_data[face] = nil
        end
      end
      data[tn] = tooth_data
    end
    data
  end
end
