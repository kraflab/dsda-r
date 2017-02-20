module DemosHelper
  
  def total_time(thing, with_tics = true)
    Demo.tics_to_string(thing.demos.sum(:tics), with_tics)
  end
  
  def demo_details(thing)
    "#{pluralize(thing.demos.count, "demo")}, #{total_time(thing)}"
  end
end
