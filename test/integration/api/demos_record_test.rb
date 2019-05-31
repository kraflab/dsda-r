require 'test_helper'

class DemosRecordTest < ActionDispatch::IntegrationTest
  def setup
    @wad = wads(:btsx)
    @demo = Domain::Demo.standard_record(
      wad_id: @wad.id, level: 'Map 01', category: 'UV Speed'
    )
    @params = {
      level: @demo.level,
      wad: @wad.short_name,
      category: @demo.category_name
    }
  end

  test 'get record' do
    get '/api/demos/records', params: @params, as: :json
    response_hash = JSON.parse(response.body)
    assert_equal response_hash['time'], @demo.time
    assert_equal response_hash['level'], @demo.level
  end

  test 'missing record' do
    get '/api/demos/records', params: { wad: ':^)' }, as: :json
    response_hash = JSON.parse(response.body)
    assert_equal response_hash['error'], 'not found'
  end
end
