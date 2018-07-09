class Category < ApplicationRecord
  has_many :demos, dependent: :destroy
  validates :name,        presence: true, length: { maximum: 50 },
                          uniqueness: true
  validates :description, presence: true, length: { maximum: 200 }
  validates :game,        presence: true, length: { maximum: 50 }

  SKILL_4_SPEED = ['UV Speed', 'SM Speed'].freeze

  class << self
    def categories_for(name)
      categories = [Category.find_by(name: name)]
      categories << pacifist if skill_4_speed?(name)
      categories
    end

    def skill_4_speed?(name)
      SKILL_4_SPEED.include?(name)
    end

    def skill_4_speed
      SKILL_4_SPEED.map { |name| Category.find_by(name: name) }
    end

    def pacifist
      Category.find_by(name: 'Pacifist')
    end
  end
end
