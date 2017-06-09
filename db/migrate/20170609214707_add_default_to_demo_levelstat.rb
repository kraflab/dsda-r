class AddDefaultToDemoLevelstat < ActiveRecord::Migration[5.0]
  def up
    change_column :demos, :levelstat, :text, default: ""
  end

  def down
    change_column :demos, :levelstat, :text, default: nil
  end
end
