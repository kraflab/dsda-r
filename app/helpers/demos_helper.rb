module DemosHelper
  
  def total_time(thing, with_tics = true)
    Demo.tics_to_string(thing.demos.sum(:tics), with_tics)
  end
  
  def demo_details(thing)
    "#{pluralize(thing.demos.count, 'demo')}, #{total_time(thing)}"
  end
  
  def tagged_demos(demos)
    Tag.where(demo: demos).distinct.includes(:sub_category).where(
      'sub_categories.style & ? > 0', SubCategory.Show).references(:sub_category).count(:demo_id)
  end
  
  def last_update
    Demo.reorder(:updated_at).last.updated_at
  end
  
  def demo_level_cell(demo, chunk)
    if demo == chunk.first
      content_tag :td, demo.level, class: 'no-stripe-panel',
        rowspan: 3 * chunk.count
    end
  end
  
  def demo_category_cell(demo, chunk, wad)
    if demo == chunk.first
      content_tag :td, class: 'no-stripe-panel', rowspan: "#{3 * chunk.count}" do
        [
          demo.category.name,
          if (chunk.count > 5 and !chunk.any? { |i| i.recorded_at.nil? })
            link_to record_timeline_path(id: wad.username, level: demo.level, category: demo.category.name) do
              content_tag :span, '', class: 'glyphicon glyphicon-stats',
                'aria-hidden': 'true', 'aria-label': 'Timeline'
            end
          else
            nil
          end
        ].join(' ').html_safe
      end
    end
  end
  
  def demo_tags(demo)
    content_tag :tr, '' do
      if demo.has_shown_tag
        content_tag :td, demo.shown_tags_text, class: 'tag-text', colspan: '4'
      else
        content_tag :td, '', class: 'no-display', colspan: '4'
      end
    end
  end
end
