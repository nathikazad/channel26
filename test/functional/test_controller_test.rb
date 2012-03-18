require 'test_helper'

class TestControllerTest < ActionController::TestCase
  test "should get view1" do
    get :view1
    assert_response :success
  end

end
