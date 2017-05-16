module PlayersHelper

  def players_header(players)
    [
      content_tag(:h1, 'Player List'),
      (content_tag :p, class: 'p-short' do
        [
          pluralize(players.count, 'player'),
          if logged_in?
            link_to 'Create New Player', new_player_path,
              class: 'label label-info'
          else
            nil
          end
        ].join(' ').html_safe
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
            end,
            edit_player_link(player)
          ].join(' ').html_safe
        end)
      ].join(' ').html_safe
    end
  end

  def player_sub_header(player)
    content_tag :p, demo_details(player)
  end

  def player_stats(player, hash = {})
    hash[:longest_demo] = Demo.tics_to_string(player.demos.maximum(:tics))
    hash[:total_time], hash[:average_time] = time_stats(player, false)
    hash[:demo_count] ||= player.demos.count
    hash[:wad_count] ||= player_wad_count(player)

    # group wads by number of demos by this player, get average / max
    wad_counts = DemoPlayer.where(player: player).includes(:demo).group('demos.wad_id').references(:demo).count
    top_wad = Wad.find(wad_counts.max_by { |k, v| v }[0])
    hash[:average_demo_count] = wad_counts.keys.inject { |sum, k| sum + k } / wad_counts.size
    hash[:top_wad] = top_wad.name

    # group demos by category
    category_counts = DemoPlayer.where(player: player).includes(:demo).group('demos.category_id').references(:demo).count
    top_category = Category.find(category_counts.max_by { |k, v| v }[0])
    hash[:top_category] = top_category.name

    hash[:tas_count] ||= DemoPlayer.where(player: player).includes(:demo).where('demos.tas > 0').references(:demo).count
    hash
  end

  def edit_player_link(player)
    if logged_in?
      link_to edit_player_path(player), :class => 'btn btn-info btn-xs' do
        content_tag :span, '', class: 'glyphicon glyphicon-cog',
          'aria-hidden': 'true', 'aria-label': 'Edit'
      end
    end
  end

  def player_wad_count(player)
    DemoPlayer.where(player: player).includes(:demo).select('demos.wad_id').
      references(:demo).distinct.count
  end
end
