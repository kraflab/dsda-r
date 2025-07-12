class DemoSerializer
  def self.call(demo, base_url)
    new(demo, base_url).call
  end

  def initialize(demo, base_url)
    @demo = demo
    @base_url = base_url
  end

  def call
    missing? ? missing_demo : existing_demo
  end

  private

  attr_reader :demo, :base_url

  def missing?
    demo.nil? || demo.wad.nil?
  end

  def missing_demo
    { error: 'not found' }
  end

  def existing_demo
    {
      id: demo.id,
      players: demo.players.map(&:name),
      time: demo.time,
      category: demo.category_name,
      level: demo.level,
      wad: demo.wad.short_name,
      engine: demo.engine,
      date: demo.recorded_at,
      tic_record: demo.tic_record,
      second_record: demo.second_record,
      undisputed_record: demo.undisputed_record,
      tas: demo.tas,
      guys: demo.guys,
      suspect: demo.suspect,
      cheated: demo.cheated,
      notes: demo.sub_categories.collect { |s| s.name },
      file: base_url + demo.file_path,
      video_url: demo.video_url
    }
  end
end
