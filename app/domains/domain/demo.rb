module Domain
  module Demo
    extend self

    # Soft category pulls in related categories
    def list(
      wad_id: nil, tas: nil, guys: nil, level: nil,
      category: nil, soft_category: nil,
      order_by_tics: nil
    )
      query = ::Demo.all
      query = query.where(wad_id: wad_id) if wad_id
      query = query.where(level: level) if level
      categories = resolve_categories(category, soft_category)
      query = query.where(category: categories) if categories
      query = query.where(tas: tas) if tas
      query = query.where(guys: guys) if guys
      query = query.reorder(:tics) if order_by_tics
      query
    end

    private

    def resolve_categories(category, soft_category)
      return ::Category.find_by(name: category) if category
      return ::Category.categories_for(soft_category) if soft_category
    end
  end
end
