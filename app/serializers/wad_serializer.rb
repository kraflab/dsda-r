class WadSerializer
  def initialize(wad, base_url)
    @wad = wad
    @base_url = base_url
  end

  def call
    missing? ? missing_record : existing_record
  end

  private

  attr_reader :wad, :base_url

  def missing?
    wad.nil?
  end

  def missing_record
    { error: 'not found' }
  end

  def existing_record
    {
      short_name: wad.short_name,
      name: wad.name,
      author: wad.author,
      iwad: wad.iwad.short_name,
      file: wad.file_path ? base_url + wad.file_path : nil
    }
  end
end
