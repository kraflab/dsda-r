class AddUpdatedAtIndexToDemos < ActiveRecord::Migration[5.0]
  def change
    add_index :demos, :updated_at
  end
end
