module Errors
  module RescueError
    def self.included(base)
      base.rescue_from Errors::Unauthorized do |e|
        render json: { errors: e.message }, status: 401
      end

      base.rescue_from Errors::UnprocessableEntity do |e|
        render json: { errors: e.message }, status: 422
      end

      base.rescue_from JSON::ParserError do |e|
        render json: { errors: e.message }, status: 422
      end
    end
  end
end
