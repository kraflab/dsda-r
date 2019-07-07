class AddRecordIndexToDemos < ActiveRecord::Migration[5.0]
  def change
    add_column :demos, :record_index, :integer, default: 0
    add_index :demos, :record_index
  end
end
