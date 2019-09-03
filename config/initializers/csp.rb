SecureHeaders::Configuration.default do |config|
  config.csp = {
    default_src: %w('self'),
    script_src: %w('self' https://maxcdn.bootstrapcdn.com/ https://embed.twitch.tv/embed/v1.js),
    connect_src: %w('self'),
    img_src: %w('self'),
    font_src: %w('self' https://fonts.gstatic.com/),
    style_src: %w('self' https://fonts.googleapis.com/),
    frame_src: %w('self' https://embed.twitch.tv/),
    frame_ancestors: %w('none'),
  }
  config.csp[:script_src] << "'unsafe-inline'" if Rails.env.development?
end
