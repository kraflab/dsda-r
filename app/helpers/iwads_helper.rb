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
        if logged_in?
          link_to 'Create New Player', new_wad_path(iwad: iwad.username),
            class: 'label label-info'
        else
          nil
        end
      ].join(' ').html_safe
    end
  end

  def iwad_by_wad_count
    Hash[Iwad.all.map {|i| [i.name, i.wads.count]}]
  end
end
