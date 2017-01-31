class Iwad < ApplicationRecord
  has_many :wads, dependent: :destroy
  VALID_USERNAME_REGEX = /\A[a-z\d_-]+\z/
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
  
  private
  
    # Remove excess whitespace
    def clean_strings
      self.name     = name.strip.gsub(/\s+/, ' ')
      self.author   = author.strip.gsub(/\s+/, ' ')
    end
end
