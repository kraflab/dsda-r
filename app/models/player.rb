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

  scope :record_index_order, -> { reorder(record_index: :desc) }

  delegate :longest_demo_time, :average_demo_time, :total_demo_time,
           :average_demo_count, :most_recorded_wad, :most_recorded_category,
           :tas_count, :wad_count, :demo_count,
           to: :stats

  def twitch_url
    'https://www.twitch.tv/' + twitch if twitch.present?
  end

  def youtube_url
    'https://www.youtube.com/' + youtube if youtube.present?
  end

  def links
    l = []
    l += [twitch_url] if twitch.present?
    l += [youtube_url] if youtube.present?

    l
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
