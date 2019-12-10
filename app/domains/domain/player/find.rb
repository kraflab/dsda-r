module Domain
  module Player
    module Find
      extend self

      def call(username:, either_name:, id:)
        find_by_id(id) \
          || find_by_username(username) \
          || find_by_either_name(either_name) \
          || find_by_alias(username, either_name)
      end

      private

      def find_by_id(id)
        return unless id

        ::Player.find_by(id: id)
      end

      def find_by_username(username)
        return unless username

        ::Player.find_by(username: username)
      end

      def find_by_either_name(either_name)
        return unless either_name

        ::Player.find_by(username: either_name) || ::Player.find_by(name: either_name)
      end

      def find_by_alias(*names)
        names.compact.each do |name|
          id = ::PlayerAlias.find_by(name: name)&.player_id
          next unless id

          player = ::Player.find_by(id: id)
          return player if player
        end

        nil
      end
    end
  end
end
