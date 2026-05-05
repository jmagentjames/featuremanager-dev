require "test_helper"

class PasswordsControllerTest < ActionDispatch::IntegrationTest
  test "change password page requires login" do
    get edit_password_url
    assert_redirected_to login_url
  end

  test "change password with correct current password succeeds" do
    user = User.create!(name: "Alice", email: "alice_#{SecureRandom.hex}@example.com",
                        password: "password123", password_confirmation: "password123")
    post login_url, params: { email: user.email, password: "password123" }
    patch password_url, params: { current_password: "password123",
                                   password: "newpassword456", password_confirmation: "newpassword456" }
    assert_redirected_to root_url
    assert user.reload.authenticate("newpassword456")
  end

  test "change password with wrong current password fails" do
    user = User.create!(name: "Alice", email: "alice_#{SecureRandom.hex}@example.com",
                        password: "password123", password_confirmation: "password123")
    post login_url, params: { email: user.email, password: "password123" }
    patch password_url, params: { current_password: "wrong",
                                   password: "newpassword456", password_confirmation: "newpassword456" }
    assert_response :unprocessable_entity
    assert user.reload.authenticate("password123")
  end
end
