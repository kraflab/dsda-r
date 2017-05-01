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
  
  def edit_player_link(player)
    if logged_in?
      link_to edit_player_path(player), :class => 'btn btn-info btn-xs' do
        content_tag :span, '', class: 'glyphicon glyphicon-cog', 
          'aria-hidden': 'true', 'aria-label': 'Edit'
      end
    end
  end
end
