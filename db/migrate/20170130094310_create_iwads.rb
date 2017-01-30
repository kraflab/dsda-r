class CreateIwads < ActiveRecord::Migration[5.0]
  def change
    create_table :iwads do |t|
      t.string :name
      t.string :username
      t.string :author

      t.timestamps
    end
    add_index :iwads, :username, unique: true
  end
end
