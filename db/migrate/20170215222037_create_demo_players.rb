class CreateDemoPlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :demo_players do |t|
      t.references :demo, foreign_key: true, index: true
      t.references :player, foreign_key: true, index: true

      t.timestamps
    end
    add_index :demo_players, [:demo_id, :player_id], unique: true
  end
end
