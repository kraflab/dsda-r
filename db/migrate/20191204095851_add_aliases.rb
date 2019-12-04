class AddAliases < ActiveRecord::Migration[5.0]
  def change
    create_table :aliases do  |t|
      t.string :name
      t.integer :player_id

      t.timestamps
    end

    add_index :aliases, :name, unique: true
  end
end
