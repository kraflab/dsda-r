class DemoCreationService
  BASE_ATTRIBUTES = [
    :time, :tas, :guys, :level, :recorded_at, :levelstat, :engine,
    :version, :category_name, :video_link
  ].freeze

  def initialize(request_hash)
    @request_hash = request_hash
  end

  def create!
    new_demo.tap { |demo| demo.save! }
  end

  private

  def new_demo
    Demo.new(demo_attributes)
  end

  def demo_attributes
    @request_hash.slice(*BASE_ATTRIBUTES).merge(
      wad: wad, demo_file: demo_file, players: players, sub_categories: sub_categories
    )
  end

  def wad
    @wad ||= Wad.find_by(username: @request_hash[:wad_username])
  end

  def players
    @players ||= @request_hash[:players].map do |name|
      Player.find_by(username: name) || Player.find_by!(name: name)
    end
  end

  def sub_categories
    @sub_categories ||= @request_hash[:tags].map do |tag|
      SubCategory.find_by(name: tag[:text]) ||
        SubCategory.create(name: tag[:text], show: tag[:style])
    end
  end

  def new_file
    io = Base64StringIO.new(Base64.decode64(@request_hash[:file][:data]))
    io.original_filename = @request_hash[:file][:name][0..23]
    DemoFile.new(wad: wad, data: io)
  end

  def has_file_data?
    @request_hash[:file] && @request_hash[:file][:data] && @request_hash[:file][:name]
  end

  def demo_file
    return new_file if has_file_data?
    return DemoFile.find(@request_hash[:file_id]) if @request_hash[:file_id].present?
  end
end
