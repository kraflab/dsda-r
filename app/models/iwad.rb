class Iwad < ApplicationRecord
  has_many :wads, dependent: :destroy
  default_scope -> { order(:username) }
  validates :name,     presence: true, length: { maximum: 50 }
  validates :username, presence: true, length: { maximum: 50 },
                       uniqueness: true,
                       format: { with: VALID_USERNAME_REGEX }
  validates :author,   presence: true, length: { maximum: 50 }

  # Override path
  def to_param
    username
  end

  def wads_count
    wads.count
  end
end
