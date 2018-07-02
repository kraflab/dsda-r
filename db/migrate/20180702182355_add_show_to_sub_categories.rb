class AddShowToSubCategories < ActiveRecord::Migration[5.0]
  def up
    add_column :sub_categories, :show, :boolean, default: true

    SubCategory.all.each do |sc|
      sc.show = sc.style.positive?
      sc.save!
    end
  end

  def down
    remove_column :sub_categories, :show, :boolean, default: true
  end
end
