require "test_helper"

class Admin::DashboardControllerTest < ActionDispatch::IntegrationTest
  test "unauthenticated user cannot access admin" do
    get admin_root_url
    assert_redirected_to root_path
  end

  test "non-admin user cannot access admin" do
    user = User.create!(name: "Regular", email: "regular_#{SecureRandom.hex}@example.com",
                        password: "password123", password_confirmation: "password123")
    post login_url, params: { email: user.email, password: "password123" }
    get admin_root_url
    assert_redirected_to root_path
  end

  test "admin user can access dashboard" do
    admin = User.create!(name: "Admin", email: "admin_#{SecureRandom.hex}@example.com",
                         password: "password123", password_confirmation: "password123", admin: true)
    post login_url, params: { email: admin.email, password: "password123" }
    get admin_root_url
    assert_response :success
  end
end
