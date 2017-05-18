class ModifyWadsIndex < ActiveRecord::Migration[5.0]
  def change
    remove_index :wads, :iwad_id
  end
end
