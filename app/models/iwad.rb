class Iwad < ApplicationRecord
  has_many :wads, dependent: :destroy
  has_many :demos, through: :wads
  default_scope -> { order(:short_name) }
  validates :name,       presence: true, length: { maximum: 50 }
  validates :short_name, presence: true, length: { maximum: 50 },
                         uniqueness: true,
                         format: { with: VALID_USERNAME_REGEX }
  validates :author,     presence: true, length: { maximum: 50 }

  delegate :average_demo_time, :total_demo_time, :demo_count, :player_count,
           :wad_count, to: :stats

  # Override path
  def to_param
    short_name
  end

  private

  def stats
    @stats ||= Domain::Iwad::Stats.call(self)
  end
end
