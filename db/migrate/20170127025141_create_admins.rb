class CreateAdmins < ActiveRecord::Migration[5.0]
  def change
    create_table :admins do |t|
      t.string :username
      t.string :password_digest

      t.timestamps
    end
    add_index :admins, :username, unique: true
  end
end
