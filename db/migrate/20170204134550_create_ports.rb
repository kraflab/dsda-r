class CreatePorts < ActiveRecord::Migration[5.0]
  def change
    create_table :ports do |t|
      t.string :file
      t.string :family
      t.string :version

      t.timestamps
    end
    add_index :ports, [:family, :version], unique: true
  end
end
