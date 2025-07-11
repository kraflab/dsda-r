module Errors
  class Unauthorized < StandardError; end
  class UnprocessableEntity < StandardError; end
  class TooManyMatches < StandardError; end
  class NoMatches < StandardError; end

  module RescueError
    def self.included(base)
      base.rescue_from Errors::Unauthorized do |e|
        render json: { errors: 'Unauthorized' }, status: 401
      end

      base.rescue_from OtpHandler::Invalid do |e|
        render json: { errors: 'Unauthorized' }, status: 401
      end

      base.rescue_from Errors::UnprocessableEntity do |e|
        render json: { errors: 'Unprocessable Entity' }, status: 422
      end

      base.rescue_from JSON::ParserError do |e|
        render json: { errors: 'JSON error' }, status: 422
      end

      base.rescue_from ActiveRecord::RecordInvalid do |e|
        render json: { errors: e.record.errors.messages }, status: 422
      end

      base.rescue_from Errors::TooManyMatches do |e|
        render json: { errors: 'Multiple matches found! Cannot update.' },
          status: 422
      end

      base.rescue_from Errors::NoMatches do |e|
        render json: { errors: 'No matches found! Cannot update.' },
          status: 404
      end

      base.rescue_from ActiveRecord::RecordNotFound do |e|
        respond_to do |format|
          format.html { render 'static_pages/not_found', status: :not_found }
          format.json { render json: { errors: 'Not found' }, status: :not_found }
        end
      end
    end
  end
end
