module PortsHelper
  
  def ports_header(ports)
    [
      content_tag(:h1, 'Port List'),
      if logged_in?
        content_tag :p, class: 'p-short' do
          link_to 'Create New Port', new_port_path, class: 'label label-info'
        end
      else
        nil
      end
    ].join(' ').html_safe
  end
end
