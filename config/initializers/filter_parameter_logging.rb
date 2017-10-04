# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += [:password, 'demo.file.data', 'wad.file.data', 'port.file.data']
