class PlayerSerializer
  def self.call(player)
    new(player).call
  end

  def initialize(player)
    @player = player
  end

  def call
    missing? ? missing_player : existing_player
  end

  private

  attr_reader :player

  def missing?
    player.nil?
  end

  def missing_player
    { error: 'not found' }
  end

  def existing_player
    {
      username: player.username,
      name: player.name,
      stats: {
        demo_count: player.demo_count,
        total_demo_time: player.total_demo_time,
        average_demo_time: player.average_demo_time,
        longest_demo_time: player.longest_demo_time,
      }
    }
  end
end
