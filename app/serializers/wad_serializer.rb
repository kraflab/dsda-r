class WadSerializer
  def initialize(wad)
    @wad = wad
  end

  def call
    {
      save: true,
      id: @wad.id,
      file_id: @wad.wad_file_id
    }
  end
end
