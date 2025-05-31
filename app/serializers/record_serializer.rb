class RecordSerializer
  def self.call(demo, wad, base_url)
    new(demo, wad, base_url).call
  end

  def initialize(demo, wad, base_url)
    @demo = demo
    @wad = wad
    @base_url = base_url
  end

  def call
    missing? ? missing_record : existing_record
  end

  private

  attr_reader :demo, :wad, :base_url

  def missing?
    demo.nil? || wad.nil?
  end

  def missing_record
    { error: 'not found' }
  end

  def existing_record
    {
      player: demo.players.first.name,
      time: demo.time,
      category: demo.category_name,
      level: demo.level,
      wad: wad.short_name,
      wad_name: wad.name,
      engine: demo.engine,
      date: demo.recorded_at,
      notes: demo.sub_categories.collect { |s| s.name },
      file: base_url + demo.file_path
    }
  end
end
