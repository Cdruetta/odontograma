class ToothState < ApplicationRecord
  belongs_to :odontogram
  has_many :state_histories, dependent: :nullify

  validates :tooth_number, presence: true
  validates :face, presence: true, inclusion: { in: Odontogram::FACES }
  validates :state, presence: true, inclusion: { in: Odontogram::STATES.keys.map(&:to_s) }
  validates :tooth_number, uniqueness: { scope: [:odontogram_id, :face], message: "ya existe un estado para este diente/cara" }

  before_save :set_color

  private

  def set_color
    self.color = Odontogram::STATES[state.to_sym]&.dig(:color)
  end
end
