class AddRecordIndexToPlayers < ActiveRecord::Migration[5.0]
  def up
    add_column :players, :record_index, :integer, default: 0
    add_index :players, :record_index
  end

  def down
    remove_index :players, :record_index
    remove_column :players, :record_index
  end
end
