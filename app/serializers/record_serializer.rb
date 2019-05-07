class RecordSerializer
  def self.call(demo, wad)
    new(demo, wad).call
  end

  def initialize(demo, wad)
    @demo = demo
    @wad = wad
  end

  def call
    missing? ? missing_record : existing_record
  end

  private

  attr_reader :demo, :wad

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
      wad: wad.username,
      engine: demo.engine,
      date: demo.recorded_at
    }
  end
end
