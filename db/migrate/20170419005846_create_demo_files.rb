class CreateDemoFiles < ActiveRecord::Migration[5.0]
  def change
    create_table :demo_files do |t|
      t.references :wad, foreign_key: true
      t.string :data
      t.string :md5, index: true, unique: true

      t.timestamps
    end
    add_reference :demos, :demo_file, foreign_key: true, index: true
  end
end
