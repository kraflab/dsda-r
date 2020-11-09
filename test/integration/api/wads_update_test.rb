require 'test_helper'

class WadsUpdateTest < ActionDispatch::IntegrationTest
  def setup
    @wad = wads(:btsx)
    @admin = admins(:elim)
    @unauthorized_admin = admins(:bob)
    @params = {
      wad_update: {
        author: 'fred',
        parent: wads(:wad_1).short_name
      }
    }
    @wrong_params = { wad_update: @params[:wad_update].merge(iwad: 'foo') }
    setup_auth_headers
  end

  test 'authenticated wad update' do
    patch '/api/wads/btsx', params: @params, as: :json, headers: @headers
    @wad.reload
    assert_equal @wad.author, 'fred'
    assert_equal @wad.parent, wads(:wad_1)
    response_hash = JSON.parse(response.body)
    assert response_hash['save']
    assert_equal response_hash['id'], @wad.id
    assert_equal response_hash['file_id'], @wad.wad_file.id
  end

  test 'invalid wad update' do
    patch '/api/wads/btsx', params: @wrong_params, as: :json, headers: @headers
    assert_equal @wad.author, @wad.reload.author
    assert_equal response.status, 422
    assert_includes response.body, '"iwad":["must exist'
  end

  test 'unauthenticated wad update' do
    patch '/api/wads/btsx', params: @params, as: :json, headers: @wrong_headers
    assert_equal @wad.author, @wad.reload.author
    assert_equal response.status, 401
    assert_includes response.body, 'Unauthorized'
  end

  test 'unauthorized wad update' do
    patch '/api/wads/btsx', params: @params, as: :json, headers: @unauthorized_headers
    assert_equal @wad.author, @wad.reload.author
    assert_equal response.status, 401
    assert_includes response.body, 'Unauthorized'
  end
end
