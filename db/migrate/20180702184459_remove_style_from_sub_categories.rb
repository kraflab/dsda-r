class RemoveStyleFromSubCategories < ActiveRecord::Migration[5.0]
  def change
    remove_column :sub_categories, :style, :integer, default: 0
  end
end
