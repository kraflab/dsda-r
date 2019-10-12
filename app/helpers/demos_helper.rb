module DemosHelper
  def demo_feed_sub_header
    content_tag :p do
      [
        link_to('Sort by Record Date', feed_path(sort_by: 'record_date')),
        link_to('Sort by Upload Date', feed_path(sort_by: 'upload_date'))
      ].join(' | ').html_safe
    end
  end

  def compare_movies_list(demos)
    content_tag :ul, class: 'dropdown-menu' do
      demos.collect do |demo|
        content_tag :li do
          content_tag :a, demo.movie_text, href: '#'
        end
      end.join(' ').html_safe
    end
  end

  def time_diff_secs(first, second)
    spl1 = time_split(first)
    spl2 = time_split(second)
    spl1[1] - spl2[1] + (spl1[2] - spl2[2]) * 60 + (spl1[3] - spl2[3]) * 3600
  end

  def time_split(time)
    return if time.blank?
    spl = time.split('.')
    spl.push 0 if spl.count != 2
    fields = spl[0].split(':').reverse
    fields.push 0 while fields.count < 3
    ([spl.last] + fields).collect { |i| i.to_i }
  end

  def total_time(thing, with_cs = true)
    Service::Tics::ToString.call(thing.demos.sum(:tics), with_cs: with_cs)
  end

  def count_and_total_time(thing, with_cs = true)
    result = thing.demos.reorder(nil).pluck('sum(demos.tics), count(*)').first
    OpenStruct.new(
      total_time: Service::Tics::ToString.call(result[0] || 0, with_cs: with_cs),
      count: result[1]
    )
  end

  def demo_details(thing)
    "#{pluralize(thing.demos.count, 'demo')}, #{total_time(thing)}"
  end

  def last_update
    Demo.reorder(:id).last.created_at
  end

  def map_number_to_episode(n)
    n == 31 || n == 32 ? 2 : ((n - 1) / 10 + 1)
  end

  def demo_episode(level)
    /E(?<ep>\d*)M/.match(level) do |m|
      return [m[:ep]] if m[:ep].present?
    end

    /Map (?<ep>\d*)/.match(level) do |m|
      return [map_number_to_episode(m[:ep].to_i)] if m[:ep]
    end

    /Ep (?<ep>\d*)/.match(level) do |m|
      return [m[:ep]] if m[:ep]
    end

    []
  end

  def demo_video_link(demo)
    content_tag :td do
      if !demo.video_link.blank?
        content_tag :a, href: "https://www.youtube.com/watch?v=#{demo.video_link}", target: :_blank do
          content_tag :span, '', class: 'glyphicon glyphicon-play',
            'aria-hidden': 'true', 'aria-label': 'Video'
        end
      else
        nil
      end
    end
  end

  def demo_time_cell(demo)
    time_text = demo.time
    unless demo.has_tics
      time_text += '   '
    end
    content_tag :td, class: 'right-text demo-time' do
      link_to(time_text, demo.file_path, title: demo.levelstat)
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
          if (chunk.count > 5 and !chunk.any? { |i| i.recorded_at.nil? }) && demo.category_name != 'Other'
            link_to record_timeline_path(id: wad.short_name, level: demo.level, category: demo.category.name) do
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
        content_tag :td, demo.shown_tags_text, class: 'tag-text', colspan: '5'
      else
        content_tag :td, '', class: 'no-display', colspan: '5'
      end
    end
  end

  def demo_note_cell(demo)
    content_tag :td, class: 'note-cell' do
      [
        demo_record_glyph(demo),
        second_record_glyph(demo),
        demo.note
      ].compact.join(' ').html_safe
    end
  end

  def demo_record_glyph(demo)
    return unless demo.tic_record?

    content_tag :span, '', class: 'glyphicon glyphicon-king',
      'aria-hidden': 'true', 'aria-label': 'Record', 'title': 'Record'
  end

  def second_record_glyph(demo)
    return unless demo.second_record?

    content_tag :span, '', class: 'glyphicon glyphicon-time',
      'aria-hidden': 'true', 'aria-label': 'Second Record', 'title': 'Second Record'
  end
end
