class AddCompatibilityToDemos < ActiveRecord::Migration[5.0]
  def change
    add_column :demos, :compatibility, :integer, default: 0
  end
end
