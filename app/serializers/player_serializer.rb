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
      stats: FastStats.count_and_total_time(player, false).table
    }
  end
end
