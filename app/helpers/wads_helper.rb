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

  def wads_header(wads)
    [
      content_tag(:h1, 'Wad List'),
      (content_tag :p, class: 'p-short' do
        pluralize(wads.count, 'wad')
      end)
    ].join(' ').html_safe
  end

  def table_view_wad_sub_header(wad)
    content_tag :p, class: 'p-short' do
      [
        demo_details(wad),
        '|',
        link_to('Stats', wad_stats_path(wad)),
        '|',
        wad_view_selector(wad),
        '|',
        category_selector(wad)
      ].join(' ').html_safe
    end
  end

  def leaderboard_wad_sub_header(wad, category, level)
    content_tag :p, class: 'p-short' do
      [
        demo_details(wad),
        '|',
        link_to('Stats', wad_stats_path(wad)),
        '|',
        wad_view_selector(wad),
        '|',
        level_selector(wad, category: category),
        '|',
        category_selector(wad, level: level)
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

  def wad_sub_header(wad, category, level)
    content_tag :p, class: 'p-short' do
      [
        demo_details(wad),
        '|',
        link_to('Stats', wad_stats_path(wad)),
        '|',
        wad_view_selector(wad),
        '|',
        level_selector(wad, category: category),
        '|',
        category_selector(wad, level: level)
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

  def path_from_selector(level: nil, category: nil)
    if action_name == "show" then
      wad_path(level: level, category: category)
    elsif action_name == "table_view" then
      wad_table_view_path(category: category)
    elsif action_name == "leaderboard" then
      wad_leaderboard_path(level: level, category: category)
    end
  end

  def wad_view_selector(wad)
    options = [
      ["Default View", wad_path(wad)],
      ["Table View", wad_table_view_path(wad)],
      ["Leaderboard", wad_leaderboard_path(wad)]
    ]

    content_tag :span do
      select_tag = content_tag :select, class: "fix-dropdown", title: "View Select", onchange: "location = this.value;" do
        options.map do |label, path|
          content_tag(:option, label, value: path, selected: current_page?(path))
        end.join.html_safe
      end

      [select_tag, content_tag(:span, '', class: 'caret')].join.html_safe
    end
  end

  def category_selector(wad, level: nil)
    options = Domain::Category.list(iwad: wad.iwad_short_name).compact.map do |category|
      [
        category.name,
        path_from_selector(level: level, category: category.name)
      ]
    end

    if action_name == "show"
      options.unshift(['Category Select', path_from_selector(level: level), true])
    end

    content_tag :span do
      select_tag = content_tag :select, class: "fix-dropdown", title: "Category Select", onchange: "location = this.value;" do
        options.map do |label, path, default|
          content_tag(:option, label, value: path, selected: default || current_page?(path))
        end.join.html_safe
      end

      [select_tag, content_tag(:span, '', class: 'caret')].join.html_safe
    end
  end

  def level_selector(wad, category: nil)
    first = wad.demos.ils.select(:level).distinct.first
    first ||= wad.demos.movies.select(:level).distinct.first
    return '' if first.nil?

    options = []

    # Allow grouped levels only in the default view
    if action_name == "show" then
      options << ["Map Select", path_from_selector(category: category)]

      wad_episodes(wad).collect do |episode|
        options << [episode, path_from_selector(level: episode, category: category)]
      end

      if wad.demos.movies.any?
        options << ["Movies", path_from_selector(level: "Movies", category: category)]
      end
    end

    wad.demos.ils.select(:level).distinct.collect do |field|
      options << [field.level, path_from_selector(level: field.level, category: category)]
    end

    wad.demos.movies.select(:level).distinct.collect do |field|
      options << [field.level, path_from_selector(level: field.level, category: category)]
    end

    content_tag :span do
      select_tag = content_tag :select, class: "fix-dropdown", title: "Map Select", onchange: "location = this.value;" do
        options.map do |label, path, default|
          content_tag(:option, label, value: path, selected: default || current_page?(path))
        end.join.html_safe
      end

      [select_tag, content_tag(:span, '', class: 'caret')].join.html_safe
    end
  end
end
