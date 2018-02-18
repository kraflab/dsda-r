class WadCreationService
  BASE_ATTRIBUTES = [:name, :username, :author, :year, :compatibility, :is_commercial, :single_map].freeze

  def initialize(request_hash)
    @request_hash = request_hash
  end

  def create!
    new_wad.tap { |wad| wad.save! }
  end

  private

  def new_wad
    Wad.new(wad_attributes)
  end

  def wad_attributes
    @request_hash.slice(*BASE_ATTRIBUTES).merge(iwad: iwad, wad_file: wad_file)
  end

  def iwad
    @iwad ||= Iwad.find_by(name: @request_hash[:iwad]) || Iwad.find_by(username: @request_hash[:iwad])
  end

  def new_file
    io = Base64StringIO.new(Base64.decode64(@request_hash[:file][:data]))
    io.original_filename = @request_hash[:file][:name][0..23]
    WadFile.new(iwad: iwad, data: io)
  end

  def has_file_data?
    @request_hash[:file] && @request_hash[:file][:data] && @request_hash[:file][:name]
  end

  def wad_file
    return new_file if has_file_data?
    return WadFile.find(@request_hash[:file_id]) if @request_hash[:file_id].present?
  end
end
