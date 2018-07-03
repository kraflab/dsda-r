class AddNameIndexToPlayers < ActiveRecord::Migration[5.0]
  def change
    add_index :players, :name
  end
end
