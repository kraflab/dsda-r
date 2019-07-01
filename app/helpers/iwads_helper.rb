module IwadsHelper

  def iwads_header(iwads)
    [
      content_tag(:h1, 'Iwad List'),
      (content_tag :p, class: 'p-short' do
        pluralize(iwads.count, 'iwad')
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
        link_to('Stats', iwad_stats_path(iwad))
      ].join(' ').html_safe
    end
  end

  def iwad_stats(iwad, hash = {})
    hash[:total_time] = iwad.total_demo_time
    hash[:demo_count] = iwad.demo_count
    hash[:player_count] = iwad.player_count
    hash[:wad_count] = iwad.wad_count
    hash[:average_time] = iwad.average_demo_time
    hash
  end
end
