require 'test_helper'

class PortsCreateTest < ActionDispatch::IntegrationTest
  def setup
    @admin = admins(:elim)
    @params = {
      port: {
        family: 'zdoom',
        version: 'v2.7',
        file: { data: '1234', name: 'zdoom.zip' }
      }
    }
    @wrong_params = { port: @params[:port].merge(family: nil) }
    @headers = {
      'HTTP_API_USERNAME' => @admin.username,
      'HTTP_API_PASSWORD' => 'password1234'
    }
    @wrong_headers = {
      'HTTP_API_USERNAME' => @admin.username,
      'HTTP_API_PASSWORD' => 'password5678'
    }
  end

  test 'authenticated port upload' do
    post '/api/ports/', params: @params, as: :json, headers: @headers
    created_port = Port.find_by(family: 'zdoom', version: 'v2.7')
    assert created_port.present?
    response_hash = JSON.parse(response.body)
    assert response_hash['save']
    assert_equal response_hash['port']['id'], created_port.id
    assert_equal response_hash['port']['name'], created_port.full_name
  end

  test 'invalid port upload' do
    post '/api/ports/', params: @wrong_params, as: :json, headers: @headers
    assert_nil Port.find_by(family: 'zdoom', version: 'v2.7')
    assert_equal response.status, 422
    assert_includes response.body, '"family":["can\'t be blank'
  end

  test 'unauthenticated port upload' do
    post '/api/ports/', params: @params, as: :json, headers: @wrong_headers
    assert_nil Port.find_by(family: 'zdoom', version: 'v2.7')
    assert_equal response.status, 401
    assert_includes response.body, 'Unauthorized'
  end
end
