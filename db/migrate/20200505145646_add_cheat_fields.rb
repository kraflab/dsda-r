class AddCheatFields < ActiveRecord::Migration[5.0]
  def change
    add_column :demos, :cheated, :boolean, default: false
    add_column :players, :cheater, :boolean, default: false
  end
end
