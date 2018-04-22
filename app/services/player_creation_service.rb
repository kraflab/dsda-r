class PlayerCreationService
  BASE_ATTRIBUTES = [:name, :username, :twitch, :youtube].freeze

  def initialize(request_hash)
    @request_hash = request_hash
  end

  def create!
    new_player.tap { |player| player.save! }
  end

  private

  def new_player
    Player.new(player_attributes)
  end

  def player_attributes
    @request_hash.slice(*BASE_ATTRIBUTES)
  end
end
