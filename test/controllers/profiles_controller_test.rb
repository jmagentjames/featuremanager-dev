require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(name: "Test User", email: "profile_#{SecureRandom.hex}@example.com",
                         password: "password123", password_confirmation: "password123")
    post login_url, params: { session: { email: @user.email, password: "password123" } }
  end

  test "show profile page" do
    get profile_url
    assert_response :success
    assert_includes response.body, @user.name
    assert_includes response.body, @user.email
  end

  test "successful update" do
    patch profile_url, params: { user: { name: "New Name", email: "new_#{SecureRandom.hex}@example.com" } }
    assert_redirected_to profile_path
    follow_redirect!
    @user.reload
    assert_equal "New Name", @user.name
  end

  test "failed update with invalid email" do
    patch profile_url, params: { user: { name: "New Name", email: "invalid" } }
    assert_response :unprocessable_entity
    @user.reload
    assert_not_equal "invalid", @user.email
  end

  test "successful self-deletion with correct password" do
    assert_difference "User.count", -1 do
      delete profile_url, params: { password: "password123" }
    end
    assert_redirected_to root_path
    follow_redirect!
    assert_includes response.body, "Ditt konto har raderats"
  end

  test "rejected deletion with wrong password" do
    assert_no_difference "User.count" do
      delete profile_url, params: { password: "wrongpassword" }
    end
    assert_redirected_to profile_path
    follow_redirect!
    assert_includes response.body, "Felaktigt lösenord"
  end

  test "unauthenticated access redirects to login" do
    delete logout_url
    get profile_url
    assert_redirected_to login_path
  end
end
