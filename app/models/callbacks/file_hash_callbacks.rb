class FileHashCallbacks

  # Compute md5 hash on validation
  def before_validation(model)
    model.md5 = if model.data and model.data.file and model.data.file.file
      Digest::MD5.hexdigest(model.data.file.read)
    else
      nil
    end
  end
end
