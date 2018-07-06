class Wad < ApplicationRecord
  belongs_to :iwad, touch: true
  belongs_to :wad_file, autosave: true, optional: true
  has_many :demos, dependent: :destroy
  has_many :demo_files
  default_scope -> { order(:username) }
  validates :iwad_id,  presence: true
  validates :name,     presence: true, length: { maximum: 50 }
  validates :username, presence: true, length: { maximum: 50 },
                       uniqueness: true,
                       format: { with: VALID_USERNAME_REGEX }
  validates :author,   presence: true, length: { maximum: 50 }
  validates_associated :wad_file

  delegate :longest_demo_time, :average_demo_time, :total_demo_time,
           :most_recorded_player, :player_count, :demo_count,
           to: :stats

  # Override path
  def to_param
    username
  end

  def file_path
    wad_file.data.url if wad_file
  end

  def record(level, category, guys, tas)
    run_demos(level, category, guys, tas).first
  end

  def run_demos(level, category, guys, tas)
    run_categories = [Category.find_by(name: category)]
    if ['UV Speed', 'SM Speed'].include?(category)
      run_categories << Category.find_by(name: 'Pacifist')
    end

    demos.where(tas: tas, guys: guys, level: level, category: run_categories).reorder(:tics)
  end

  private

  def stats
    @stats ||= Domain::Wad::Stats.call(self)
  end
end
