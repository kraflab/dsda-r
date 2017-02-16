class CreateTags < ActiveRecord::Migration[5.0]
  def change
    create_table :tags do |t|
      t.references :sub_category, foreign_key: true, index: true
      t.references :demo, foreign_key: true, index: true

      t.timestamps
    end
    add_index :tags, [:sub_category_id, :demo_id], unique: true
  end
end
