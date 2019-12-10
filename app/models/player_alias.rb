class PlayerAlias < ApplicationRecord
  validates :name, uniqueness: true, presence: true
  validates :player_id, presence: true
end
