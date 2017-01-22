class CreatePlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :players do |t|
      t.string :name
      t.string :username
      t.string :twitch
      t.string :youtube

      t.timestamps
    end
    add_index :players, :username, unique: true
  end
end
