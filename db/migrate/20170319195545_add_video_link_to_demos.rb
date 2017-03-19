class AddVideoLinkToDemos < ActiveRecord::Migration[5.0]
  def change
    add_column :demos, :video_link, :string
  end
end
