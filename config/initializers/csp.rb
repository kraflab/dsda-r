SecureHeaders::Configuration.default do |config|
  config.csp = {
    default_src: %w('self'),
    script_src: %w('self' https://maxcdn.bootstrapcdn.com/),
    connect_src: %w('self'),
    img_src: %w('self'),
    font_src: %w('self' https://fonts.gstatic.com/),
    style_src: %w('self' https://fonts.googleapis.com/),
  }
end