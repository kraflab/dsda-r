class AddUndisputedRecordToDemo < ActiveRecord::Migration[5.0]
  def change
    add_column :demos, :undisputed_record, :boolean, default: false
  end
end
