require 'test_helper'

class TwilioresppControllerTest < ActionController::TestCase
  test "should get answerMachine" do
    get :answerMachine
    assert_response :success
  end

end
