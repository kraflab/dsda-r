class AddParentWad < ActiveRecord::Migration[5.2]
  def change
    add_reference :wads, :parent, foreign_key: true
  end
end
