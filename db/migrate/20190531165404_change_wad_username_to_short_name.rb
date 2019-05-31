class ChangeWadUsernameToShortName < ActiveRecord::Migration[5.0]
  def change
    rename_column :wads, :username, :short_name
    rename_column :iwads, :username, :short_name
  end
end
