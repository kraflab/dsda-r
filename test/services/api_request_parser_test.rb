require 'test_helper'

describe ApiRequestParser do
  let(:request) {
    OpenStruct.new(body: OpenStruct.new(read: body_hash.to_json))
  }
  let(:parser) {
    ApiRequestParser.new(request: request, require: required_keys)
  }
  let(:body_hash) { { wad: [{ deep: 3 }, 2] } }
  let(:required_keys) { [:wad] }

  describe '#parse_json' do
    let(:parse_json) { parser.parse_json }

    it 'converts request body into a hash with deep symbols' do
      parse_json.must_equal body_hash
    end

    describe 'when a required key is missing' do
      let(:required_keys) { [:wad, :player] }

      it 'raises an error' do
        proc { parse_json }.must_raise Errors::UnprocessableEntity
      end
    end
  end
end
