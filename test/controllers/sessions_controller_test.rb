require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "login page renders" do
    get login_url
    assert_response :success
  end

  test "login with valid credentials redirects to home" do
    user = User.create!(name: "Test User", email: "test_#{SecureRandom.hex}@example.com",
                        password: "password123", password_confirmation: "password123")
    post login_url, params: { session: { email: user.email, password: "password123" } }
    assert_redirected_to root_url
    assert_equal user.id, session[:user_id]
  end

  test "login with invalid credentials shows error" do
    post login_url, params: { session: { email: "nobody@example.com", password: "wrong" } }
    assert_response :unprocessable_entity
    assert_nil session[:user_id]
  end

  test "logout destroys session" do
    user = User.create!(name: "Test User", email: "test_#{SecureRandom.hex}@example.com",
                        password: "password123", password_confirmation: "password123")
    post login_url, params: { session: { email: user.email, password: "password123" } }
    delete logout_url
    assert_redirected_to root_url
    assert_nil session[:user_id]
  end
end
