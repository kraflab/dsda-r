class AddHasTagToDemos < ActiveRecord::Migration[5.0]
  def up
    add_column :demos, :has_hidden_tag, :boolean, default: false
    add_column :demos, :has_shown_tag, :boolean, default: false
    Demo.all.each do |demo|
      demo.has_hidden_tag = demo.sub_categories.where('style & ? = 0', SubCategory.Show).exists?
      demo.has_shown_tag = demo.sub_categories.where('style & ? > 0', SubCategory.Show).exists?
      demo.save!
    end
  end
  
  def down
    remove_column :demos, :has_hidden_tag, :boolean, default: false
    remove_column :demos, :has_shown_tag, :boolean, default: false
  end
end
