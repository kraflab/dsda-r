class AddParentWad < ActiveRecord::Migration[5.2]
  def change
    add_column :wads, :parent_id, :integer, default: nil
    add_index :wads, :parent_id
  end
end
