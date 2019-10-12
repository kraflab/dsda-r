class AddBasePathToWadFile < ActiveRecord::Migration[5.0]
  def up
    add_column :wad_files, :base_path, :string, allow_nil: false

    WadFile.all.each do |wad_file|
      wad_file.update_column(:base_path, "#{wad_file.iwad.short_name}")
    end
  end

  def down
    remove_column :wad_files, :base_path
  end
end
