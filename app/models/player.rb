class Player < ApplicationRecord
  VALID_USERNAME_REGEX = /\A[a-z\d_]+\z/
  validates :name,     presence: true, length: { maximum: 50 }
  validates :username, presence: true, length: { maximum: 50 },
                       format: { with: VALID_USERNAME_REGEX }
  validates :twitch,  length: { maximum: 50 }
  validates :youtube, length: { maximum: 50 }
  before_save :clean_strings
  
  # Convert name to valid username
  def default_username
    name.downcase.strip.gsub(/\s+/, '_').gsub(/[^a-z\d_]+/, '')
  end
  
  private
  
    # Downcase and remove whitespace
    def clean_strings
      self.twitch   = twitch.downcase.gsub(/\s+/, '')
      self.youtube  = youtube.downcase.gsub(/\s+/, '')
      self.name     = name.gsub(/\s+/, ' ')
    end
end
