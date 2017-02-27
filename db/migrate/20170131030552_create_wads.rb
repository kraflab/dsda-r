class CreateWads < ActiveRecord::Migration[5.0]
  def change
    create_table :wads do |t|
      t.string :name
      t.string :username
      t.string :author
      t.string :file
      t.string :year
      t.string :compatibility
      t.boolean :is_commercial
      t.integer :versions
      t.references :iwad, foreign_key: true, index: true

      t.timestamps
    end
    add_index :wads, :username, unique: true
    add_index :wads, [:iwad_id, :username]
  end
end
