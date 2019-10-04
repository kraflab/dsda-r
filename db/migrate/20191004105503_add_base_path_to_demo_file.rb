class AddBasePathToDemoFile < ActiveRecord::Migration[5.0]
  def up
    add_column :demo_files, :base_path, :string, allow_nil: false

    DemoFile.all.each do |demo_file|
      demo_file.update_column(:base_path, "#{demo_file.wad.short_name}")
    end
  end

  def down
    remove_column :demo_files, :base_path
  end
end
