class AddMd5ToPorts < ActiveRecord::Migration[5.0]
  def change
    rename_column :ports, :file, :data
    add_column :ports, :md5, :string
    add_index :ports, :md5, unique: true
  end
end
