class DemoPlayer < ApplicationRecord
  belongs_to :demo, touch: true
  belongs_to :player, touch: true
  validates :demo_id,   presence: true
  validates :player_id, presence: true
end
