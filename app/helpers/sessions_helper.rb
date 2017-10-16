module SessionsHelper
  def demo_filter_array
    JSON.parse(cookies['demo_filter'])
  end
end
