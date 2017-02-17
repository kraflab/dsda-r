module DemosHelper
  
  def total_time(thing)
    Demo.tics_to_string(thing.demos.sum(:tics))
  end
  
  def demo_details(thing)
    "#{pluralize(thing.demos.count, "demo")}, #{total_time(thing)}"
  end
end
