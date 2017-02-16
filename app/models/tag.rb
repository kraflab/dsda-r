class Tag < ApplicationRecord
  belongs_to :sub_category
  belongs_to :demo
  validates :sub_category_id, presence: true
  validates :demo_id,         presence: true
end
