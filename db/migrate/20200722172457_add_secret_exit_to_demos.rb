class AddSecretExitToDemos < ActiveRecord::Migration[5.2]
  def change
    add_column :demos, :secret_exit, :boolean, default: false
  end
end
