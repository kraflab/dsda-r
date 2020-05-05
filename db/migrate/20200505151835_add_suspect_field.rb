class AddSuspectField < ActiveRecord::Migration[5.0]
  def change
    add_column :demos, :suspect, :boolean, default: false
  end
end
