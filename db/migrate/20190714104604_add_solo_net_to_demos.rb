class AddSoloNetToDemos < ActiveRecord::Migration[5.0]
  def change
    add_column :demos, :solo_net, :boolean, default: false
  end
end
