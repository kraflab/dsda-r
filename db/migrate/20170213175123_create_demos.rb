class CreateDemos < ActiveRecord::Migration[5.0]
  def change
    create_table :demos do |t|
      t.integer :tics
      t.integer :cl
      t.string :level
      t.datetime :recorded_at
      t.text :levelstat
      t.string :file
      t.references :player, foreign_key: true, index: true
      t.references :wad, foreign_key: true, index: true
      t.references :category, foreign_key: true
      t.references :port, foreign_key: true

      t.timestamps
    end
    add_index :demos, [:wad_id, :level, :category_id, :tics]
  end
end
