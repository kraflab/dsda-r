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
  
  def demo_hidden_tag(demo)
    content_tag :td, class: 'right-text' do
      [
        if demo.has_hidden_tag
          content_tag :a, '*', id: demo.id, class: 'hidden-tag'
        else
          nil
        end,
        demo.note
      ].join(' ').html_safe
    end
  end
  
  def demo_time_cell(demo)
    content_tag :td, class: 'right-text demo-time' do
      [
        link_to(demo.time, demo.file_path, title: demo.levelstat),
        if logged_in?
          link_to edit_demo_path(demo), class: 'label label-info label-xs' do
            content_tag :span, '', class: 'glyphicon glyphicon-cog',
              'aria-hidden': 'true', 'aria-label': 'Edit'
          end
        else
          nil
        end
      ].join(' ').html_safe
    end
  end
  
  def demo_level_cell(demo, chunk)
    if demo == chunk.first
      content_tag :td, demo.level, class: 'no-stripe-panel',
        rowspan: 3 * chunk.count
    end
  end
  
  def demo_category_cell(demo, chunk, wad)
    if demo == chunk.first
      content_tag :td, class: 'no-stripe-panel', rowspan: 3 * chunk.count do
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
  
  def demo_category_cell_lite(demo, chunk)
    if demo == chunk.first
      content_tag :td, demo.category.name, class: 'no-stripe-panel',
        rowspan: 3 * chunk.count
    end
  end
  
  def demo_wad_cell(demo, chunk, name)
    if demo == chunk.first
      content_tag :td, class: 'wadfile no-stripe-panel', rowspan: 3 * chunk.count do
        link_to name, demo.wad
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
