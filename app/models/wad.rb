class Wad < ApplicationRecord
  belongs_to :iwad
  default_scope -> { order(:username) }
  validates :iwad_id, presence: true
  validates :name,     presence: true, length: { maximum: 50 }
  validates :username, presence: true, length: { maximum: 50 },
                       uniqueness: true,
                       format: { with: VALID_USERNAME_REGEX }
  validates :file,     length: { maximum: 50 }, allow_blank: true,
                       format: { with: VALID_USERNAME_REGEX }
  validates :author,   presence: true, length: { maximum: 50 }
  before_save   :clean_strings
  before_update :clean_strings
  
  # Override path
  def to_param
    username
  end
  
  def iwad_username
    if iwad_id
      Iwad.find(iwad_id).username
    else
      ""
    end
  end
  
  private
  
    # Remove excess whitespace
    def clean_strings
      self.name     = name.strip.gsub(/\s+/, ' ')
      self.author   = author.strip.gsub(/\s+/, ' ')
    end
end
