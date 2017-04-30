module WadsHelper
  
  def wad_header(wad)
    content_tag :h1 do
      [
        wad.name,
        content_tag(:small, wad.author),
        edit_wad_link(wad)
      ].join(' ').html_safe
    end
  end
  
  def wad_sub_header(wad)
    content_tag :p, class: 'p-short' do
      [
        demo_details(wad),
        new_demo_link(wad)
      ].join(' ').html_safe
    end
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
