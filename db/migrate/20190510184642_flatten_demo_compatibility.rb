class FlattenDemoCompatibility < ActiveRecord::Migration[5.0]
  def up
    add_column :demos, :compatible, :boolean, default: true

    Demo.where(compatibility: 3).update_all(compatible: false)

    remove_column :demos, :compatibility
  end

  def down
    remove_column :demos, :compatible
    add_column :demos, :compatibility, :integer, default: 0
  end
end
