require "test_helper"

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = User.create!(name: "Admin", email: "admin_#{SecureRandom.hex}@example.com",
                          password: "password123", password_confirmation: "password123", admin: true)
    @other_user = User.create!(name: "Other", email: "other_#{SecureRandom.hex}@example.com",
                               password: "password123", password_confirmation: "password123", admin: false)
    post login_url, params: { session: { email: @admin.email, password: "password123" } }
  end

  test "admin can list users" do
    get admin_users_url
    assert_response :success
    assert_includes response.body, @admin.name
    assert_includes response.body, @other_user.name
  end

  test "admin can toggle admin status" do
    assert_not @other_user.admin?
    patch toggle_admin_admin_user_url(@other_user)
    assert_redirected_to admin_users_path
    @other_user.reload
    assert @other_user.admin?

    patch toggle_admin_admin_user_url(@other_user)
    @other_user.reload
    assert_not @other_user.admin?
  end

  test "admin can reset password" do
    post reset_password_admin_user_url(@other_user)
    assert_redirected_to admin_users_path
    @other_user.reload
    assert_not_nil @other_user.reset_password_token
  end

  test "admin can delete another user" do
    assert_difference "User.count", -1 do
      delete admin_user_url(@other_user)
    end
    assert_redirected_to admin_users_path
  end

  test "admin cannot delete themselves" do
    assert_no_difference "User.count" do
      delete admin_user_url(@admin)
    end
    assert_redirected_to admin_users_path
    follow_redirect!
    assert_includes response.body, "Du kan inte ta bort ditt eget konto"
  end

  test "unauthenticated user cannot access admin users" do
    delete logout_url
    get admin_users_url
    assert_redirected_to root_path
  end
end
