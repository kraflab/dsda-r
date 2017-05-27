module WadsHelper

  def record_timeline_header(wad, level, category)
    content_tag :h1, "Record Timeline | #{wad.name} #{level} #{category}"
  end

  def wads_header(wads)
    [
      content_tag(:h1, 'Wad List'),
      (content_tag :p, class: 'p-short' do
        [
          pluralize(wads.count, 'wad'),
          if logged_in?
            link_to 'Create New Wad', new_wad_path, class: 'label label-info'
          else
            nil
          end
        ].join(' ').html_safe
      end)
    ].join(' ').html_safe
  end

  def wad_header(wad)
    content_tag :h1 do
      [
        link_to(wad.name, wad.file_path),
        content_tag(:small, wad.author),
        edit_wad_link(wad)
      ].join(' ').html_safe
    end
  end

  def wad_sub_header(wad)
    content_tag :p, class: 'p-short' do
      [
        demo_details(wad),
        link_to('Stats', wad_stats_path(wad)),
        new_demo_link(wad)
      ].join(' ').html_safe
    end
  end

  def wad_stats(wad, hash = {})
    hash[:longest_demo] = Demo.tics_to_string(wad.demos.maximum(:tics))
    hash[:total_time], hash[:average_time] = time_stats(wad, false)
    hash[:demo_count] ||= wad.demos.count
    hash[:player_count] ||= DemoPlayer.includes(:demo).where('demos.wad_id = ?', wad.id).references(:demo).select(:player_id).distinct.count

    # group players by number of demos for this wad, get max
    player_counts = DemoPlayer.includes(:demo).where('demos.wad_id = ?', wad.id).references(:demo).group(:player_id).count
    top_player = Player.find(player_counts.max_by { |k, v| v }[0])
    hash[:top_player] = top_player.name
    hash
  end

  def edit_wad_link(wad)
    if logged_in?
      link_to edit_wad_path(wad), :class => 'btn btn-info btn-xs' do
        content_tag :span, '', class: 'glyphicon glyphicon-cog',
          'aria-hidden': 'true', 'aria-label': 'Edit'
      end
    end
  end

  def new_demo_link(wad)
    if logged_in?
      link_to 'Create New Demo', new_demo_path(wad: wad.username),
        :class => 'label label-info'
    end
  end
end
