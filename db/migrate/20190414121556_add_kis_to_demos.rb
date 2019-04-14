class AddKisToDemos < ActiveRecord::Migration[5.0]
  def change
    add_column :demos, :kills, :string, default: nil
    add_column :demos, :items, :string, default: nil
    add_column :demos, :secrets, :string, default: nil
  end
end
