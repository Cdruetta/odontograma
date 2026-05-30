class Patient < ApplicationRecord
  has_many :odontograms, dependent: :destroy

  validates :name, presence: true

  def current_odontogram
    odontograms.order(version: :desc).first
  end

  def adult?
    return true if birth_date.nil?
    age >= 18
  end

  def age
    return nil if birth_date.nil?
    now = Time.current.to_date
    now.year - birth_date.year - ((now.month > birth_date.month || (now.month == birth_date.month && now.day >= birth_date.day)) ? 0 : 1)
  end
end
