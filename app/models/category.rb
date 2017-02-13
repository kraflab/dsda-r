class Category < ApplicationRecord
  has_many :demos, dependent: :destroy
  validates :name,        presence: true, length: { maximum: 50 },
                          uniqueness: true
  validates :description, presence: true, length: { maximum: 200 }
  before_save   :clean_strings
  before_update :clean_strings
  
  private
  
    # Remove excess whitespace
    def clean_strings
      self.name.strip.gsub!(/\s+/, ' ')
      self.description.strip.gsub!(/\s+/, ' ')
    end
end
