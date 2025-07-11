class Wad < ApplicationRecord
  belongs_to :iwad, touch: true
  belongs_to :wad_file, autosave: true, optional: true
  belongs_to :parent, optional: true, class_name: 'Wad'
  has_many :demos, dependent: :destroy
  has_many :demo_files
  default_scope -> { order(:short_name) }
  validates :iwad_id,    presence: true
  validates :name,       presence: true, length: { maximum: 255 }
  validates :short_name, presence: true, length: { maximum: 50 },
                         uniqueness: true,
                         format: { with: VALID_USERNAME_REGEX }
  validates :author,     presence: true, length: { maximum: 255 }
  validates_associated :wad_file

  delegate :longest_demo_time, :average_demo_time, :total_demo_time,
           :most_recorded_player, :player_count, :demo_count,
           to: :stats

  delegate :short_name, to: :iwad, prefix: true

  # Override path
  def to_param
    short_name
  end

  def file_path
    wad_file.data.url if wad_file
  end

  private

  def stats
    @stats ||= Domain::Wad::Stats.call(self)
  end
end
