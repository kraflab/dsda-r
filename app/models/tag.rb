class Tag < ApplicationRecord
  belongs_to :sub_category
  belongs_to :demo, touch: true
  validates :sub_category_id, presence: true
  validates :demo_id,         presence: true
  after_save :update_players, :update_demos

  private
  
    # if a tag is added to a demo, the player needs to be touched
    def update_players
      demo.players.each { |i| i.touch }
    end
    
    # reset demo tag flags
    def update_demos
      demo.update_tags
    end
end
