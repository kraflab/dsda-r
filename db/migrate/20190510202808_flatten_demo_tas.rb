class FlattenDemoTas < ActiveRecord::Migration[5.0]
  def up
    rename_column :demos, :tas, :tas_temp

    add_column :demos, :tas, :boolean, default: false

    Demo.where('tas_temp != 0').update_all(tas: true)

    remove_column :demos, :tas_temp
  end

  def down
    rename_column :demos, :tas, :tas_temp

    add_column :demos, :tas, :integer, default: 0

    Demo.where(tas_legacy: true).update_all(tas: 1)

    remove_column :demos, :tas_temp
  end
end
