class ModifyDemosIndex < ActiveRecord::Migration[5.0]
  def change
    add_index :demos, :recorded_at
    remove_index :demos, :wad_id
  end
end
