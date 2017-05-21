class AddGameToCategories < ActiveRecord::Migration[5.0]
  def up
    add_column :categories, :game, :string, default: 'Doom'
    add_index :categories, :game

    category_to_game = Hash.new('Doom')
    category_to_game['SM Speed'] = 'Heretic'
    category_to_game['SM Max'] = 'Heretic'
    category_to_game['BP Max'] = 'Heretic'
    category_to_game['BP Speed'] = 'Heretic'
    Category.all.each do |category|
      category.game = category_to_game[category.name]
      category.save!
    end
  end

  def down
    remove_index :categories, :game
    remove_column :categories, :game
  end
end
