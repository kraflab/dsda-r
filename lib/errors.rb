module Errors
  class Unauthorized < StandardError; end
  class UnprocessableEntity < StandardError; end

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

      base.rescue_from ActiveRecord::RecordInvalid do |e|
        render json: { errors: e.record.errors.messages }, status: 422
      end
    end
  end
end
