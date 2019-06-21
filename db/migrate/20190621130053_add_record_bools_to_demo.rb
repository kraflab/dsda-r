class AddRecordBoolsToDemo < ActiveRecord::Migration[5.0]
  def change
    add_column :demos, :tic_record, :boolean, default: false
    add_column :demos, :second_record, :boolean, default: false
  end
end
