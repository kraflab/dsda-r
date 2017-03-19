class AddSingleMapToWads < ActiveRecord::Migration[5.0]
  def change
    add_column :wads, :single_map, :boolean, default: false
  end
end
