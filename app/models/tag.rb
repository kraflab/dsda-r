class Tag < ApplicationRecord
  belongs_to :sub_category
  belongs_to :demo, touch: true
  validates :sub_category, presence: true
  validates :demo,         presence: true
end
