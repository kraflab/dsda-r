class SubCategory < ApplicationRecord
  has_many :tags, dependent: :destroy
  has_many :demos, through: :tags
  validates :name,  presence: true, length: { maximum: 200 }

  scope :shown, -> { where(show: true) }
  scope :hidden, -> { where(show: false) }
end
