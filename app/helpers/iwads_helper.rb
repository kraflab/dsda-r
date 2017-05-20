module IwadsHelper

  def iwads_header(iwads)
    [
      content_tag(:h1, 'Iwad List'),
      (content_tag :p, class: 'p-short' do
        [
          pluralize(iwads.count, 'iwad'),
          if logged_in?
            link_to 'Create New Iwad', new_iwad_path,
              class: 'label label-info'
          else
            nil
          end
        ].join(' ').html_safe
      end)
    ].join(' ').html_safe
  end

  def iwad_header(iwad)
    content_tag :h1 do
      [
        iwad.name,
        (content_tag :small do
          iwad.author
        end)
      ].join(' ').html_safe
    end
  end

  def iwad_sub_header(iwad)
    content_tag :p, class: 'p-short' do
      [
        pluralize(iwad.wads.count, 'wad'),
        link_to('Stats', iwad_stats_path(iwad)),
        if logged_in?
          link_to 'Create New Player', new_wad_path(iwad: iwad.username),
            class: 'label label-info'
        else
          nil
        end
      ].join(' ').html_safe
    end
  end

  def iwad_stats(iwad, hash = {})
    demos = Demo.where(wad: @iwad.wads)
    total_time = demos.sum(:tics)
    hash[:total_time] = Demo.tics_to_string(total_time, false)
    hash[:demo_count] = demos.count
    hash[:player_count] = DemoPlayer.where(demo: demos).select(:player_id).distinct.count
    hash[:wad_count] = iwad.wads.count
    hash[:average_time] = Demo.tics_to_string(total_time / hash[:demo_count], false)
    hash
  end

  def iwad_by_wad_count
    Hash[Iwad.all.map {|i| [i.name, i.wads.count]}]
  end
end
