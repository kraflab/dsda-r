module ApplicationHelper

  # Returns the full title on a per-page basis
  def full_title(page_title = '')
    base_title = 'DSDA'
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  def flash_messages(flash)
    flash.collect do |message_type, message|
      sub_message = message.split('%%')
      content_tag :div, class: "alert alert-#{message_type} alert-modest left-text" do
        if sub_message.count == 1
          message
        else
          [
            content_tag(:strong, sub_message[0]),
            sub_message[1]
          ].join(' ').html_safe
        end
      end
    end.join(' ').html_safe
  end

  # Returns the number of demos by yyyy-mm
  def demos_by_month(subset)
    subset.reorder(:recorded_at).group_by { |i| i.recorded_at.nil? ? nil :
      i.recorded_at.strftime('%Y-%m') }.inject({}) do |hash, (k, v)|
        hash[k] = v.size if k
        hash
      end
  end
end
