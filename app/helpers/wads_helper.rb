module WadsHelper

  def record_timeline_header(wad, level, category)
    content_tag :h1, "Record Timeline | #{wad.name} #{level} #{category}"
  end

  def compare_movies_header(wad, level, category)
    content_tag :h1, "Compare Movies | #{wad.name} #{level} #{category}"
  end

  def compare_movies_pairs(first_demo, second_demo)
    first_times = first_demo.levelstat.split("\n")
    second_times = second_demo.levelstat.split("\n")
    if first_times.size == second_times.size
      first_times.zip(second_times).collect do |first, second|
        [first, second, time_diff_secs(first, second)]
      end
    else
      nil
    end
  end

  def table_view_category_list(wad)
    content_tag :ul, class: 'dropdown-menu' do
      Domain::Category.list(iwad: wad.iwad_short_name).map do |cat|
        content_tag :li do
          link_to(cat.name, wad_table_view_path(wad, category: cat.name))
        end
      end.join(' ').html_safe
    end
  end

  def leaderboard_category_list(wad, level)
    content_tag :ul, class: 'dropdown-menu' do
      Domain::Category.list(iwad: wad.iwad_short_name).map do |cat|
        content_tag :li do
          link_to(cat.name, wad_leaderboard_path(wad, level: level, category: cat.name))
        end
      end.join(' ').html_safe
    end
  end

  def wads_header(wads)
    [
      content_tag(:h1, 'Wad List'),
      (content_tag :p, class: 'p-short' do
        pluralize(wads.count, 'wad')
      end)
    ].join(' ').html_safe
  end

  def table_view_wad_sub_header(wad)
    content_tag :p, class: 'p-short one-line' do
      [
        demo_details(wad),
        '|',
        link_to('Default View', wad_path(wad)),
        '|',
        link_to('Stats', wad_stats_path(wad)),
        '|',
        category_selector(wad)
      ].join(' ').html_safe
    end
  end

  def leaderboard_wad_sub_header(wad, category, level)
    content_tag :p, class: 'p-short one-line' do
      [
        demo_details(wad),
        '|',
        link_to('Default View', wad_path(wad)),
        '|',
        link_to('Stats', wad_stats_path(wad)),
        '|',
        leaderboard_level_selector(wad, category),
        '|',
        leaderboard_category_selector(wad, level)
      ].join(' ').html_safe
    end
  end

  def wad_version_banner(wad)
    return unless wad.parent

    content_tag :div, class: 'alert alert-danger' do
      [
        'This wad has a more recent ',
        link_to('version', wad_path(wad.parent), class: 'alert-link'),
        '.'
      ].join.html_safe
    end
  end

  def wad_header(wad)
    content_tag :h1 do
      [
        link_to(wad.name, wad.file_path),
        content_tag(:small, wad.author)
      ].join(' ').html_safe
    end
  end

  def wad_sub_header(wad)
    content_tag :p, class: 'p-short one-line' do
      [
        demo_details(wad),
        '|',
        link_to('Table View', wad_table_view_path(wad)),
        '|',
        link_to('Leaderboard', wad_leaderboard_path(wad)),
        '|',
        link_to('Stats', wad_stats_path(wad)),
        '|',
        level_selector(wad)
      ].join(' ').html_safe
    end
  end

  def active_wad_entry(wad, demo_count)
    content_tag :tr, class: 'row-no-top' do
      [
        (content_tag :td, class: 'no-wrap' do
          link_to(wad.name, wad_path(wad), class: 'one-line')
        end),
        (content_tag :td, class: 'no-wrap' do
          "#{demo_count}"
        end)
      ].join(' ').html_safe
    end
  end

  def wad_stats(wad, hash = {})
    hash[:longest_demo] = wad.longest_demo_time
    hash[:total_time] = wad.total_demo_time
    hash[:average_time] = wad.average_demo_time
    hash[:demo_count] ||= wad.demo_count
    hash[:player_count] ||= wad.player_count
    hash[:top_player] = wad.most_recorded_player
    hash
  end

  def wad_episodes(wad)
    episodes = []
    wad.demos.reorder(:level).select(:level).distinct.each do |demo|
      episodes = episodes + demo_episode(demo.level)
    end
    episodes.uniq{ |x| x.to_i }.collect do |ep|
      "Episode #{ep} ILs"
    end
  end

  def category_selector(wad)
    content_tag :div, id: 'levelSelectDropdown', class: 'one-line ' do
      content_tag :div, class: 'btn-group shift-right' do
        [
          (content_tag :button, type: 'button', class: 'fix-dropdown dropdown-toggle', 'data-toggle': 'dropdown', 'aria-haspopup': 'true', 'aria-expanded': 'false' do
            [
              'Category Select',
              (content_tag :span, '', class: 'caret')
            ].join(' ').html_safe
          end),
          table_view_category_list(wad)
        ].join(' ').html_safe
      end
    end
  end

  def leaderboard_category_selector(wad, level)
    content_tag :div, id: 'levelSelectDropdown', class: 'one-line ' do
      content_tag :div, class: 'btn-group shift-right' do
        [
          (content_tag :button, type: 'button', class: 'fix-dropdown dropdown-toggle', 'data-toggle': 'dropdown', 'aria-haspopup': 'true', 'aria-expanded': 'false' do
            [
              'Category Select',
              (content_tag :span, '', class: 'caret')
            ].join(' ').html_safe
          end),
          leaderboard_category_list(wad, level)
        ].join(' ').html_safe
      end
    end
  end

  def leaderboard_level_selector(wad, category)
    content_tag :div, id: 'levelSelectDropdown', class: 'one-line ' do
      content_tag :div, class: 'btn-group shift-right' do
        [
          (content_tag :button, type: 'button', class: 'fix-dropdown dropdown-toggle', 'data-toggle': 'dropdown', 'aria-haspopup': 'true', 'aria-expanded': 'false' do
            [
              'Map Select',
              (content_tag :span, '', class: 'caret')
            ].join(' ').html_safe
          end),
          (content_tag :ul, class: 'dropdown-menu scrollable-menu' do
            (wad.demos.ils.select(:level).distinct.collect do |field|
              content_tag :li do
                content_tag :a, field.level, href: wad_leaderboard_path(level: field.level, category: category)
              end
            end +
            wad.demos.movies.select(:level).distinct.collect do |field|
              content_tag :li do
                content_tag :a, field.level, href: wad_leaderboard_path(level: field.level, category: category)
              end
            end).join(' ').html_safe
          end)
        ].join(' ').html_safe
      end
    end
  end

  def level_selector(wad)
    first = wad.demos.ils.select(:level).distinct.first
    first ||= wad.demos.movies.select(:level).distinct.first
    return '' if first.nil?
    content_tag :div, id: 'levelSelectDropdown', class: 'one-line ' do
      content_tag :div, class: 'btn-group shift-right' do
        [
          (content_tag :button, type: 'button', class: 'fix-dropdown dropdown-toggle', 'data-toggle': 'dropdown', 'aria-haspopup': 'true', 'aria-expanded': 'false' do
            [
              'Map Select',
              (content_tag :span, '', class: 'caret')
            ].join(' ').html_safe
          end),
          (content_tag :ul, class: 'dropdown-menu scrollable-menu' do
            (wad_episodes(wad).collect do |ep|
              (content_tag :li do
                content_tag :a, ep, href: wad_path(level: ep)
              end)
            end +
            [
              if wad.demos.movies.any?
                content_tag :li do
                  content_tag :a, 'Movies', href: wad_path(level: 'Movies')
                end
              end
            ] +
            wad.demos.ils.select(:level).distinct.collect do |field|
              content_tag :li do
                content_tag :a, field.level, href: wad_path(level: field.level)
              end
            end +
            wad.demos.movies.select(:level).distinct.collect do |field|
              content_tag :li do
                content_tag :a, field.level, href: wad_path(level: field.level)
              end
            end).join(' ').html_safe
          end)
        ].join(' ').html_safe
      end
    end
  end
end
