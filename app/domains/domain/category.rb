module Domain
  module Category
    extend self

    SKILL_4_SPEED = ['UV Speed', 'SM Speed'].freeze

    def list(soft_category: nil, only: nil)
      return categories_for(soft_category) if soft_category
      return skill_4_speed if only == :skill_4_speed
      ::Category.all
    end

    def single(name: nil, id: nil, assert: false)
      category = nil
      category = ::Category.find_by(name: name) if name
      category = ::Category.find_by(id: id) if id
      return category if category.present?
      raise ActiveRecord::RecordNotFound if assert
    end

    private

    def categories_for(name)
      categories = [::Category.find_by(name: name)]
      categories << pacifist if skill_4_speed?(name)
      categories
    end

    def skill_4_speed?(name)
      SKILL_4_SPEED.include?(name)
    end

    def skill_4_speed
      SKILL_4_SPEED.map { |name| ::Category.find_by(name: name) }
    end

    def pacifist
      ::Category.find_by(name: 'Pacifist')
    end
  end
end
