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
  before_validation   :clean_strings
  before_validation   :check_username
  after_save :update_demos, if: :name_changed?

  # Convert name to valid username
  def self.default_username(name)
    I18n.transliterate(name).downcase.strip.gsub(/\s+/, '_').gsub(/[^a-z\d_-]+/, '')
  end

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
    'https://www.twitch.tv/' + twitch
  end

  # Return the player's youtube url
  def youtube_url
    'https://www.youtube.com/' + youtube
  end

  def absorb!(other)
    other_demos = DemoPlayer.where(player: other)
    other_demos.each do |demo|
      demo.player = self
      demo.save
    end
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

    def update_demos
      demos.each { |i| i.touch }
    end

    def clean_strings
      self.twitch   ||= ''
      self.youtube  ||= ''
      self.name     = name.strip.gsub(/\s+/, ' ')
    end

    def check_username
      self.username = Player.default_username(name) if username.blank?
    end
end
