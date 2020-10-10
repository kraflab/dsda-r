module Domain
  module Demo
    extend self

    def find_matches(details)
      FindMatches.call(details)
    end

    def single(id: nil, assert: false)
      demo = nil
      demo = ::Demo.find_by(id: id) if id
      return demo if demo.present?
      raise ActiveRecord::RecordNotFound if assert
    end

    def standard_record_list(wad_id:, levels:, category:, very_soft: nil)
      FindStandardRecordList.call(
        wad_id, levels, category: category, very_soft: very_soft
      )
    end

    def standard_record(wad_id:, level:, category:, very_soft: nil)
      FindStandardRecord.call(
        wad_id, level, category: category, very_soft: very_soft
      )
    end

    # Soft category pulls in related categories
    def list(
      wad_id: nil, tas: nil, guys: nil, level: nil, standard: nil,
      category: nil, soft_category: nil, categories: nil,
      order_by_tics: nil, order_by_record_date: nil, order_by_id: nil,
      solo_net: nil, page: nil
    )
      query = ::Demo.all
      query = query.where(wad_id: wad_id) if wad_id
      query = query.where(level: level) if level
      categories ||= resolve_categories(category, soft_category)
      query = query.where(category: categories) if categories
      query = query.where(tas: tas) if !tas.nil?
      query = query.where(solo_net: solo_net) if !solo_net.nil?
      query = query.where(guys: guys) if guys
      query = query.standard if standard
      query = query.reorder(:tics) if order_by_tics
      query = query.reorder(recorded_at: order_by_record_date) if order_by_record_date
      query = query.reorder(id: order_by_id) if order_by_id
      query = query.page(page) if page
      query
    end

    def create(
      wad:, category:, time:, level:, tas: false, guys:, players:,
      tags: nil, compatible: true, version: 0, video_link: nil, levelstat: '',
      recorded_at: nil, engine: 'Unknown', file: nil, file_id: nil,
      kills: nil, items: nil, secrets: nil, solo_net: false, secret_exit: false
    )
      wad = Domain::Wad.single(either_name: wad)
      category = Domain::Category.single(name: category)
      players = players_from_names(players)
      Domain::Demo::Create.call(
        wad: wad,
        category: category,
        time: time,
        level: level,
        tas: tas,
        solo_net: solo_net,
        guys: guys,
        players: players,
        tags: tags,
        compatible: compatible,
        version: version,
        video_link: video_link,
        levelstat: levelstat,
        recorded_at: recorded_at,
        engine: engine,
        file: file,
        file_id: file_id,
        kills: kills,
        items: items,
        secrets: secrets,
        secret_exit: secret_exit
      )
    end

    def update(id:, wad: nil, category: nil, players: nil, **attributes)
      attributes[:wad] = Domain::Wad.single(either_name: wad) if wad
      attributes[:category] = Domain::Category.single(name: category) if category
      attributes[:players] = players_from_names(players) if players
      Domain::Demo::Update.call(::Demo.find(id), attributes)
    end

    def delete(id:)
      Domain::Demo::Delete.call(::Demo.find(id))
    end

    def demo_count_by_year
      Hash[::DemoYear.all.map { |dy| [dy.year, dy.count]}]
    end

    private

    def players_from_names(names)
      names.map do |name|
        Domain::Player.single(
          either_name: name, assert: true, create_missing: true
        )
      end
    end

    def resolve_categories(category, soft_category)
      return Domain::Category.single(name: category) if category
      return Domain::Category.list(soft_category: soft_category) if soft_category
    end
  end
end
