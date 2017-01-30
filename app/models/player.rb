class Player < ApplicationRecord
  VALID_USERNAME_REGEX = /\A[a-z\d_-]+\z/
  validates :name,     presence: true, length: { maximum: 50 }
  validates :username, presence: true, length: { maximum: 50 },
                       uniqueness: true,
                       format: { with: VALID_USERNAME_REGEX }
  validates :twitch,   length: { maximum: 50 }, allow_blank: true,
                       format: { with: VALID_USERNAME_REGEX }
  validates :youtube,  length: { maximum: 50 }, allow_blank: true,
                       format: { with: VALID_USERNAME_REGEX }
  before_save   :clean_strings
  before_update :clean_strings
  
  # Convert name to valid username
  def Player.default_username(name)
    name.downcase.strip.gsub(/\s+/, '_').gsub(/[^a-z\d_-]+/, '')
  end
  
  # Return the player's twitch url
  def twitch_url
    "https://www.twitch.tv/" + twitch
  end
  
  # Return the player's youtube url
  def youtube_url
    "https://www.youtube.com/" + youtube
  end
  
  # Override path
  def to_param
    username
  end
  
  private
  
    # Remove excess whitespace
    def clean_strings
      self.twitch   ||= ""
      self.youtube  ||= ""
      self.name     = name.strip.gsub(/\s+/, ' ')
    end
end
