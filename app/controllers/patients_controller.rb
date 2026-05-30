class PatientsController < ApplicationController
  before_action :set_patient, only: [:show, :edit, :update, :destroy]

  def index
    @patients = Patient.order(:name)
  end

  def show
    @odontogram = @patient.current_odontogram
    if @odontogram.nil?
      auto_type = @patient.adult? ? "adult" : "child"
      @odontogram = Odontogram.create!(patient: @patient, odontogram_type: auto_type, version: 1, user_id: 1)
    end
    redirect_to patient_odontogram_path(@patient, @odontogram)
  end

  def new
    @patient = Patient.new
  end

  def create
    @patient = Patient.new(patient_params)
    if @patient.save
      redirect_to @patient, notice: "Paciente creado correctamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @patient.update(patient_params)
      redirect_to @patient, notice: "Paciente actualizado."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @patient.destroy
    redirect_to patients_path, notice: "Paciente eliminado."
  end

  private

  def set_patient
    @patient = Patient.find(params[:id])
  end

  def patient_params
    params.require(:patient).permit(:name, :birth_date, :phone, :email)
  end
end
