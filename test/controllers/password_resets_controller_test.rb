require "test_helper"

class PasswordResetsControllerTest < ActionDispatch::IntegrationTest
  test "password reset page renders" do
    get new_password_reset_url
    assert_response :success
  end

  test "password reset with valid email redirects to login" do
    user = User.create!(name: "Alice", email: "alice_#{SecureRandom.hex}@example.com",
                        password: "password123", password_confirmation: "password123")
    post password_reset_url, params: { email: user.email }
    assert_redirected_to login_url
    assert_not_nil user.reload.reset_password_token
  end

  test "password reset shows success even for unknown email (no enumeration)" do
    post password_reset_url, params: { email: "nobody@example.com" }
    assert_redirected_to login_url
  end
end
