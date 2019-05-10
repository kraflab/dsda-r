class SessionsController < ApplicationController
  def settings
    cookies.permanent['demo_filter'] ||= '{"category": [], "tas": false, "coop": false}'
  end

  def set
    demo_filter = {category: [], tas: false, coop: false, port: []}
    Domain::Category.list.each do |category|
      demo_filter[:category].push(category.name) if params["cat:#{category.name}"] == '0'
    end
    demo_filter[:tas] = params['tas'] == '0'
    demo_filter[:coop] = params['coop'] == '0'
    cookies.permanent['demo_filter'] = demo_filter.to_json
    flash.now[:info] = 'Your settings have been updated'
    render 'settings'
  end
end
