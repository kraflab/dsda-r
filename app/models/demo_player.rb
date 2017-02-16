class DemoPlayer < ApplicationRecord
  belongs_to :demo
  belongs_to :player
  validates :demo_id,   presence: true
  validates :player_id, presence: true
end
