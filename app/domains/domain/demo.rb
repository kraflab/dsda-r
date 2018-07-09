module Domain
  module Demo
    extend self

    def single(id: nil, assert: false)
      demo = nil
      demo = ::Demo.find_by(id: id) if id
      return demo if demo.present?
      raise ActiveRecord::RecordNotFound if assert
    end

    # Soft category pulls in related categories
    def list(
      wad_id: nil, tas: nil, guys: nil, level: nil,
      category: nil, soft_category: nil, categories: nil,
      order_by_tics: nil, order_by_record_date: nil, order_by_update: nil,
      page: nil
    )
      query = ::Demo.all
      query = query.where(wad_id: wad_id) if wad_id
      query = query.where(level: level) if level
      categories ||= resolve_categories(category, soft_category)
      query = query.where(category: categories) if categories
      query = query.where(tas: tas) if tas
      query = query.where(guys: guys) if guys
      query = query.reorder(:tics) if order_by_tics
      query = query.reorder(recorded_at: order_by_record_date) if order_by_record_date
      query = query.reorder(updated_at: order_by_update) if order_by_update
      query = query.page(page) if page
      query
    end

    def create(
      wad:, category:, time:, level:, tas:, guys:, players:,
      tags: nil, compatibility: 0, version: 0, video_link: nil, levelstat: '',
      recorded_at: nil, engine: 'Unknown', file: nil, file_id: nil
    )
      wad = Domain::Wad.single(either_name: wad)
      category = ::Category.find_by(name: category)
      players = players_from_names(players)
      Domain::Demo::Create.call(
        wad: wad,
        category: category,
        time: time,
        level: level,
        tas: tas,
        guys: guys,
        players: players,
        tags: tags,
        compatibility: compatibility,
        version: version,
        video_link: video_link,
        levelstat: levelstat,
        recorded_at: recorded_at,
        engine: engine,
        file: file,
        file_id: file_id
      )
    end

    private

    def players_from_names(names)
      names.map { |name| Domain::Player.single(either_name: name, assert: true) }
    end

    def resolve_categories(category, soft_category)
      return ::Category.find_by(name: category) if category
      return ::Category.categories_for(soft_category) if soft_category
    end
  end
end
