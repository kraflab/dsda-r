class AddPermissionsToAdmins < ActiveRecord::Migration[5.0]
  def change
    add_column :admins, :can_create, :boolean, default: false
    add_column :admins, :can_delete, :boolean, default: false
    add_column :admins, :can_update, :boolean, default: false
  end
end
