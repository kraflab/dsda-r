module ApplicationHelper

  # Returns a string from an active record date, which may be nil
  def safe_date(date)
    date.nil? ? 'Unknown' : date.to_date.to_s
  end

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

  # Returns the number of demos by yyyy
  def demos_by_year(subset)
    data = {}
    start_year = end_year = nil
    subset.reorder(:recorded_at).each do |demo|
      if demo.recorded_at
        start_year = demo.recorded_at.year
        break
      end
    end
    if start_year
      subset.reorder(recorded_at: :desc).each do |demo|
        if demo.recorded_at
          end_year = demo.recorded_at.year
          break
        end
      end
    end
    if start_year and end_year
      (start_year..end_year).each do |i|
        data[i] = 0
      end
    end
    subset.reorder(:recorded_at).group_by { |i| i.recorded_at.nil? ? nil :
      i.recorded_at.strftime('%Y') }.inject(data) do |hash, (k, v)|
        hash[k] = v.size if k
        hash
      end
  end

  # return the 5 most active wads of the past n days
  def active_wads(n)
    hash = Hash.new(0)
    Demo.within(n).select(:id, :wad_id).each do |demo|
      hash[demo.wad_id] += 1
    end
    hash.sort_by { |k, v| -v }[0..2]
  end

  # return the 5 most active players of the past n days
  def active_players(n)
    hash = Hash.new(0)
    DemoPlayer.includes(:demo).
      where('demos.id IN (?)', Demo.within(n).select(:id)).
      references(:demo).each do |dp|
      hash[dp.player_id] += 1
    end
    hash.sort_by { |k, v| -v }[0..2]
  end
end
