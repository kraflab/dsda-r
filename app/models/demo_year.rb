class DemoYear < ApplicationRecord
  validates :year, presence: true, uniqueness: true
  validates :count, presence: true
end
