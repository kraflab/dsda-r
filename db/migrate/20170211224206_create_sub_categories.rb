class CreateSubCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :sub_categories do |t|
      t.string :name
      t.integer :style, default: 0

      t.timestamps
    end
  end
end
