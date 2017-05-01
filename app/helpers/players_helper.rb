module PlayersHelper
  
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
