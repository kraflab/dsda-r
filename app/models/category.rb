class Category < ApplicationRecord
  has_many :demos, dependent: :destroy
  validates :name,        presence: true, length: { maximum: 50 },
                          uniqueness: true
  validates :description, presence: true, length: { maximum: 200 }
  validates :game,        presence: true, length: { maximum: 50 }
  before_save   :clean_strings
  before_update :clean_strings

  # called rarely, and few categories
  def self.select_list
    Category.all.collect { |i| [i.name, i.name] }
  end

  private

    # Remove excess whitespace
    def clean_strings
      self.name.strip.gsub!(/\s+/, ' ')
      self.description.strip.gsub!(/\s+/, ' ')
    end
end
