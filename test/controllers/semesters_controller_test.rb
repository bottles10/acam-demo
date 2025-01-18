require "test_helper"

class SemestersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get semesters_index_url
    assert_response :success
  end
end
