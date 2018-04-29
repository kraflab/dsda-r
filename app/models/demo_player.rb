class DemoPlayer < ApplicationRecord
  belongs_to :demo, touch: true
  belongs_to :player, touch: true
  validates :demo,   presence: true
  validates :player, presence: true
end
