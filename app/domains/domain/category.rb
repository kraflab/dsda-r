module Domain
  module Category
    extend self

    SKILL_4_SPEED = ['UV Speed', 'SM Speed', 'Sk4 Speed'].freeze
    SKILL_4_MAX = ['UV Max', 'SM Max', 'Sk4 Max'].freeze

    def list(
      soft_category: nil, soft_category_id: nil, only: nil, very_soft: nil,
      iwad: nil
    )
      return categories_for_name(soft_category, very_soft) if soft_category
      return categories_for_id(soft_category_id, very_soft) if soft_category_id
      return skill_4_speed if only == :skill_4_speed
      return ListForIwad.call(iwad) if iwad
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

    def categories_for_name(name, very_soft)
      base_category = ::Category.find_by(name: name)
      soft_categories_for(base_category, very_soft)
    end

    def categories_for_id(id, very_soft)
      base_category = ::Category.find_by(id: id)
      soft_categories_for(base_category, very_soft)
    end

    def soft_categories_for(base_category, very_soft)
      categories = [base_category]
      if skill_4_speed?(base_category.name)
        categories << pacifist
        categories += max if very_soft
      end
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

    def max
      SKILL_4_MAX.map { |name| ::Category.find_by(name: name) }
    end
  end
end
