class ApiRequestParser
  def initialize(options)
    @request = options[:request]
    @required_keys = options[:require] || []
  end

  def parse_json
    @request_hash = JSON.parse(@request.body.read).deep_symbolize_keys
    require_keys!
    @request_hash
  end

  private

  def require_keys!
    return if @required_keys.all? { |k| @request_hash.key? k }
    raise Errors::UnprocessableEntity, 'missing required fields'
  end
end
