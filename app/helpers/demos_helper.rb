module DemosHelper
  
  def total_time(thing, with_tics = true)
    Demo.tics_to_string(thing.demos.sum(:tics), with_tics)
  end
  
  def demo_details(thing)
    "#{pluralize(thing.demos.count, "demo")}, #{total_time(thing)}"
  end
  
  def tagged_demos(demos)
    Tag.where(demo: demos).distinct.count(:demo_id)
  end
end
