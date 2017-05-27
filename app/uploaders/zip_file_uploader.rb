class ZipFileUploader < CarrierWave::Uploader::Base
  storage :file

  # Override the directory where uploaded files will be stored.
  def store_dir
    case model.class.to_s.underscore
    when 'demo_file'
      "files/demos/#{model.wad.username}/#{model.id}/"
    when 'wad_file'
      "files/wads/#{model.iwad.username}/#{model.id}/"
    when 'port'
      "files/ports/#{model.id}/"
    else
      "files/unknown/#{model.id}/"
    end
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    '/no_file'
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_whitelist
    %w(zip)
  end

  def content_type_whitelist
    /application\/zip/
  end
end
