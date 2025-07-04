module PlayersHelper

  def players_header(players)
    [
      content_tag(:h1, 'Player List'),
      (content_tag :p, class: 'p-short' do
        pluralize(players.count, 'player')
      end)
    ].join(' ').html_safe
  end

  def player_header(player)
    content_tag :h1 do
      [
        player.name,
        (content_tag :small do
          [
            if !player.twitch.empty?
              link_to 'Twitch', player.twitch_url
            else
              nil
            end,
            if !player.youtube.empty?
              link_to 'YouTube', player.youtube_url
            else
              nil
            end
          ].join(' ').html_safe
        end)
      ].join(' ').html_safe
    end
  end

  def player_sub_header(player)
    content_tag :p do
      [
        demo_details(player),
        '|',
        link_to('Stats', player_stats_path(player)),
        '|',
        player_view_selector(player)
      ].join(' ').html_safe
    end
  end

  def player_record_view_sub_header(player)
    content_tag :p do
      [
        demo_details(player),
        '|',
        link_to('Stats', player_stats_path(player)),
        '|',
        player_view_selector(player)
      ].join(' ').html_safe
    end
  end

  def player_history_sub_header(player)
    content_tag :p do
      [
        demo_details(player),
        '|',
        link_to('Stats', player_stats_path(player)),
        '|',
        player_view_selector(player)
      ].join(' ').html_safe
    end
  end

  def active_player_entry(player, demo_count)
    content_tag :tr do
      [
        (content_tag :td, class: 'no-wrap' do
          link_to(player.name, player_path(player), class: 'one-line')
        end),
        (content_tag :td, class: 'no-wrap' do
          "#{demo_count}"
        end)
      ].join(' ').html_safe
    end
  end

  def player_stats(player, hash = {})
    hash[:longest_demo] = player.longest_demo_time
    hash[:total_time] = player.total_demo_time
    hash[:average_time] = player.average_demo_time
    hash[:demo_count] ||= player.demo_count
    hash[:wad_count] ||= player.wad_count
    hash[:average_demo_count] = player.average_demo_count
    hash[:top_wad] = player.most_recorded_wad
    hash[:top_category] = player.most_recorded_category
    hash[:tas_count] ||= player.tas_count
    hash
  end

  def player_view_selector(player)
    options = [
      ["Default View", player_path(player)],
      ["Record View", player_record_view_path(player)],
      ["History View", player_history_path(player)]
    ]

    content_tag :span do
      select_tag = content_tag :select, class: "fix-dropdown", title: "View Select" do
        options.map do |label, path|
          content_tag(:option, label, value: path, selected: current_page?(path))
        end.join.html_safe
      end

      [select_tag, content_tag(:span, '', class: 'caret')].join.html_safe
    end
  end
end
