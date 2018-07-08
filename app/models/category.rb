class Category < ApplicationRecord
  has_many :demos, dependent: :destroy
  validates :name,        presence: true, length: { maximum: 50 },
                          uniqueness: true
  validates :description, presence: true, length: { maximum: 200 }
  validates :game,        presence: true, length: { maximum: 50 }

  class << self
    def categories_for(name)
      categories = [Category.find_by(name: name)]
      categories << pacifist if skill_4_speed?(name)
    end

    def skill_4_speed?(name)
      ['UV Speed', 'SM Speed'].include?(name)
    end

    def pacifist
      Category.find_by(name: 'Pacifist')
    end
  end
end
