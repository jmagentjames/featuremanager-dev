require "test_helper"

class AboutControllerTest < ActionDispatch::IntegrationTest
  test "about page renders" do
    get about_url
    assert_response :success
  end
end
