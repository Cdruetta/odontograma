class Odontogram < ApplicationRecord
  belongs_to :patient
  has_many :tooth_states, dependent: :destroy
  has_many :state_histories, dependent: :destroy

  validates :odontogram_type, presence: true, inclusion: { in: %w[adult child] }
  validates :version, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :version, uniqueness: { scope: :patient_id }

  ADULT_TEETH = %w[
    11 12 13 14 15 16 17 18
    21 22 23 24 25 26 27 28
    31 32 33 34 35 36 37 38
    41 42 43 44 45 46 47 48
  ].freeze

  CHILD_TEETH = %w[
    51 52 53 54 55
    61 62 63 64 65
    71 72 73 74 75
    81 82 83 84 85
  ].freeze

  FACES = %w[whole occlusal incisal vestibular palatal lingual mesial distal].freeze

  STATES = {
    healthy:    { label: "Sano",         color: nil },
    carious:    { label: "Cariado",      color: "#dc3545" },
    treated:    { label: "Tratado",      color: "#0d6efd" },
    missing:    { label: "Ausente",      color: "#212529" },
    endodontics:{ label: "Endodoncia",   color: "#6f42c1" },
    prosthesis: { label: "Prótesis/Corona", color: "#ffc107" },
    implant:    { label: "Implante",     color: "#198754" }
  }.freeze

  def teeth_numbers
    odontogram_type == "child" ? CHILD_TEETH : ADULT_TEETH
  end

  def teeth_by_quadrant
    case odontogram_type
    when "child"
      {
        1 => %w[55 54 53 52 51],
        2 => %w[61 62 63 64 65],
        3 => %w[71 72 73 74 75],
        4 => %w[85 84 83 82 81]
      }
    else
      {
        1 => %w[18 17 16 15 14 13 12 11],
        2 => %w[21 22 23 24 25 26 27 28],
        3 => %w[31 32 33 34 35 36 37 38],
        4 => %w[48 47 46 45 44 43 42 41]
      }
    end
  end

  def state_for(tooth_number, face: "whole")
    tooth_states.find_by(tooth_number: tooth_number, face: face)
  end

  def color_for(tooth_number, face: "whole")
    ts = state_for(tooth_number, face: face)
    return nil unless ts
    STATES[ts.state.to_sym]&.dig(:color)
  end

  def record_change(tooth_number:, face:, old_state:, new_state:, user_id: nil)
    state_histories.create!(
      tooth_number: tooth_number,
      face: face,
      old_state: old_state,
      new_state: new_state,
      user_id: user_id,
      changed_at: Time.current
    )
  end

  def duplicate_as_new_version(user_id: nil)
    new_version = version + 1
    new_odonto = Odontogram.create!(
      patient: patient,
      odontogram_type: odontogram_type,
      version: new_version,
      user_id: user_id
    )

    tooth_states.each do |ts|
      ToothState.create!(
        odontogram: new_odonto,
        tooth_number: ts.tooth_number,
        face: ts.face,
        state: ts.state,
        color: ts.color
      )
    end

    new_odonto
  end
end
