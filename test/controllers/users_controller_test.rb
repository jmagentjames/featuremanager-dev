require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "signup page renders" do
    get signup_url
    assert_response :success
  end

  test "signup creates user and logs in" do
    email = "newuser_#{SecureRandom.hex}@example.com"
    assert_difference "User.count", 1 do
      post signup_url, params: { user: { name: "New User", email: email,
                                          password: "password123", password_confirmation: "password123" } }
    end
    assert_redirected_to root_url
    assert_not_nil session[:user_id]
  end

  test "signup with missing fields fails" do
    post signup_url, params: { user: { name: "", email: "", password: "", password_confirmation: "" } }
    assert_response :unprocessable_entity
    assert_nil session[:user_id]
  end
end
