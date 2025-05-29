module PortsHelper

  def ports_table(ports, allowed)
    ports.group_by(&:family).map do |family, ports|
      content_tag(:tr) do
        content_tag(:td, family) +
        content_tag(:td) do
          ports.each_with_index.map do |port, index|
            link = link_to(port.version, port.file_path)
            index == ports.size - 1 ? link : (link + ', ')
          end.join.html_safe
        end
      end
    end.join.html_safe
  end
end
