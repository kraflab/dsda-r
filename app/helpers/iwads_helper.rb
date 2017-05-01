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
  
  def iwad_by_wad_count
    Hash[Iwad.all.map {|i| [i.name, i.wads.count]}]
  end
end
