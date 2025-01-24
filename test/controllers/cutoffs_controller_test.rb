require "test_helper"

class CutoffsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get cutoffs_index_url
    assert_response :success
  end
end
