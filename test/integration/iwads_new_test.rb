require 'test_helper'

class IwadsNewTest < ActionDispatch::IntegrationTest

  def setup
    @admin = admins(:elim)
  end

  test "must be logged in" do
    get new_iwad_path
    assert_not flash.empty?
    assert_redirected_to root_url
    assert_no_difference "Iwad.count" do
      post iwads_path, params: { iwad:
                                   { name:   "Chex Quest", username: "chex",
                                     author: "Digital Café" } }
    end
    assert_not flash.empty?
    assert_redirected_to root_url
  end
end
