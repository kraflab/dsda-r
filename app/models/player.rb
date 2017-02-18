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
  before_save   :clean_strings
  before_update :clean_strings
  after_save :update_demos
  
  # Convert name to valid username
  def Player.default_username(name)
    I18n.transliterate(name).downcase.strip.gsub(/\s+/, '_').gsub(/[^a-z\d_-]+/, '')
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
  
    def update_demos
      demos.each { |i| i.touch }
    end
  
    # Remove excess whitespace
    def clean_strings
      self.twitch   ||= ""
      self.youtube  ||= ""
      self.name     = name.strip.gsub(/\s+/, ' ')
    end
end
