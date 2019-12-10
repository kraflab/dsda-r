class ChangeAliasToPlayerAlias < ActiveRecord::Migration[5.0]
  def change
    rename_table :aliases, :player_aliases
  end
end
