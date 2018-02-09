class WadCreationService
  def initialize(query)
    @query = query
    @wad = new_wad_from_query
    @wad.iwad = find_iwad_by_query
  end

  def create
    @response = { error: false }
    return with_errors(*@wad.errors) unless @wad.valid?

    if has_file_data?
      @wad.wad_file = create_file_from_query
      return with_errors(*wad_file.errors) unless @wad.wad_file.save
    elsif @query['file_id']
      @wad.wad_file = WadFile.find_by(id: @query['file_id'])
      return with_errors('file not found') unless @wad.wad_file
    end

    @wad.save
    return with_success(id: @wad.id, file_id: @wad.wad_file_id)
  end

  private

  def new_wad_from_query
    Wad.new(@query.slice('name', 'username', 'author', 'year', 'compatibility', 'is_commercial', 'single_map'))
  end

  def find_iwad_by_query
    Iwad.find_by(name: @query['iwad']) || Iwad.find_by(username: @query['iwad'])
  end

  def create_file_from_query
    io = Base64StringIO.new(Base64.decode64(@query['file']['data']))
    io.original_filename = @query['file']['name'][0..23]
    WadFile.new(iwad: @wad.iwad, data: io)
  end

  def with_errors(*errors)
    @response.merge(error: true, error_message: ['Wad creation failed', *errors])
  end

  def with_success(body)
    @response.merge(save: true).merge(body)
  end

  def has_file_data?
    @query['file'] && @query['file']['data'] && @query['file']['name']
  end
end
