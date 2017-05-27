class CreateWadFiles < ActiveRecord::Migration[5.0]
  def change
    create_table :wad_files do |t|
      t.references :iwad, foreign_key: true
      t.string :data
      t.string :md5, index: true, unique: true

      t.timestamps
    end
    add_reference :wads, :wad_file, foreign_key: true, index: true
    remove_column :wads, :file
  end
end
