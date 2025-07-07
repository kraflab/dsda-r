class IncreaseTextLimits < ActiveRecord::Migration[7.1]
  def change
    change_column :wads, :name, :string, limit: 255
    change_column :wads, :author, :string, limit: 255
  end
end
