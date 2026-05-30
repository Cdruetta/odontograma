class StateHistory < ApplicationRecord
  belongs_to :odontogram
  belongs_to :tooth_state, optional: true

  validates :tooth_number, presence: true
  validates :face, presence: true
  validates :new_state, presence: true
  validates :changed_at, presence: true

  scope :recent, -> { order(changed_at: :desc) }
  scope :by_user, ->(user_id) { where(user_id: user_id) }
  scope :by_tooth, ->(tooth_number) { where(tooth_number: tooth_number) }
end
