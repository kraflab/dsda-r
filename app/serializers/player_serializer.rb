class PlayerSerializer
  def initialize(player)
    @player = player
  end

  def call
    {
      save: true,
      player: {
        id: @player.id,
        username: @player.username
      }
    }
  end
end
