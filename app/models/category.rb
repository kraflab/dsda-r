class Category < ApplicationRecord
  has_many :demos, dependent: :destroy
  validates :name,        presence: true, length: { maximum: 50 },
                          uniqueness: true
  validates :description, presence: true, length: { maximum: 200 }
  validates :game,        presence: true, length: { maximum: 50 }
end
