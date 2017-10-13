class Wad < ApplicationRecord
  belongs_to :iwad, touch: true
  belongs_to :wad_file
  has_many :demos, dependent: :destroy
  has_many :demo_files
  default_scope -> { order(:username) }
  validates :iwad_id,  presence: true
  validates :name,     presence: true, length: { maximum: 50 }
  validates :username, presence: true, length: { maximum: 50 },
                       uniqueness: true,
                       format: { with: VALID_USERNAME_REGEX }
  validates :author,   presence: true, length: { maximum: 50 }
  before_save   :clean_strings
  before_update :clean_strings

  # Override path
  def to_param
    username
  end

  def iwad_username
    iwad.username if iwad
  end

  def iwad_username=(name)
    self.iwad = Iwad.find_by(username: name) unless name.blank?
    if iwad.nil?
      errors.add(:iwad_username, :not_found, message: 'not found')
    end
  end

  def file_path
    wad_file.data.url if wad_file
  end

  def record(level, category, guys, tas)
    run_demos.first
  end

  def run_demos(level, category, guys, tas)
    demos.where(tas: tas, guys: guys, level: level, category: Category.find_by(name: category))
  end

  def demos_count
    demos.count
  end

  def players_count
    demos.includes(:demo_players).references(:demo_players).select(:player_id).distinct.count
  end

  def longest_demo_time
    Demo.tics_to_string(demos.maximum(:tics))
  end

  def average_demo_time
    Demo.tics_to_string(demos.sum(:tics) / demos.count)
  end

  def total_demo_time
    Demo.tics_to_string(demos.sum(:tics))
  end

  def most_recorded_player
    player_counts = demos.includes(:demo_players).references(:demo_players).group(:player_id).count
    Player.find(player_counts.max_by { |k, v| v }[0]).name
  end

  private

    # Remove excess whitespace
    def clean_strings
      self.name     = name.strip.gsub(/\s+/, ' ')
      self.author   = author.strip.gsub(/\s+/, ' ')
    end
end
