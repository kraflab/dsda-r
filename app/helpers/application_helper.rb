module ApplicationHelper
  
  # Returns the full title on a per-page basis
  def full_title(page_title = '')
    base_title = "DSDA"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end
  
  def age_in_minutes(object)
    return ((Time.zone.now - object.created_at) / 60).to_i 
  end
end
