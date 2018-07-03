class Player < ApplicationRecord
  has_many :player_demos, class_name: "DemoPlayer", dependent: :destroy
  has_many :demos, through: :player_demos, dependent: :destroy
  default_scope -> { order(:username) }
  validates :name,     presence: true, length: { maximum: 50 }
  validates :username, presence: true, length: { maximum: 50 },
                       uniqueness: true,
                       format: { with: VALID_USERNAME_REGEX }
  validates :twitch,   length: { maximum: 50 }, allow_blank: true,
                       format: { with: VALID_USERNAME_REGEX }
  validates :youtube,  length: { maximum: 50 }, allow_blank: true,
                       format: { with: VALID_USERNAME_REGEX }
  validates :record_index, presence: true,
                           numericality: { greater_than_or_equal_to: 0 }

 delegate :longest_demo_time, :average_demo_time, :total_demo_time,
          :average_demo_count, :most_recorded_wad, :most_recorded_category,
          :tas_count, :wad_count, :demo_count,
          to: :stats

  # Calculate and save the record index for a set of players (all by default)
  def self.calculate_record_index!(players = nil)
    players ||= Player.all
    players.each do |player|
      # The bang calculates and saves before returning
      player.record_index!
    end
  end

  # Return the player's twitch url
  def twitch_url
    'https://www.twitch.tv/' + twitch if twitch.present?
  end

  # Return the player's youtube url
  def youtube_url
    'https://www.youtube.com/' + youtube if youtube.present?
  end

  def record_index!
    self.record_index = demos.reduce(0) { |sum, demo| sum + demo.record_index }
    self.save
    self.reload.record_index
  end

  # Override path
  def to_param
    username
  end

  private

  def stats
    @stats ||= Domain::Player::Stats.call(self)
  end
end
