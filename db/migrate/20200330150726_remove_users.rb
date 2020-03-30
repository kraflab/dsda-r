class RemoveUsers < ActiveRecord::Migration[5.0]
  def up
    drop_table :users
  end

  def down
    create_table :users do |t|
      t.string :username
      t.string :password_digest
      t.string :otp_secret
      t.datetime :last_otp_at
      t.boolean :can_query,  default: false
      t.boolean :can_mutate, default: false

      t.timestamps
    end

    add_index :users, :username, unique: true
  end
end
