require "test_helper"

class Admin::MessagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = User.create!(name: "Admin", email: "admin_#{SecureRandom.hex}@example.com",
                          password: "password123", password_confirmation: "password123", admin: true)
    post login_url, params: { email: @admin.email, password: "password123" }
    @message = Message.create!(name: "Bob", email: "bob@example.com", body: "Test message here")
  end

  test "admin can list messages" do
    get admin_messages_url
    assert_response :success
    assert_includes response.body, "Bob"
  end

  test "admin can view single message and marks it read" do
    get admin_message_url(@message)
    assert_response :success
    assert_includes response.body, "Test message here"
    @message.reload
    assert @message.is_read?
  end

  test "unauthenticated user cannot access admin messages" do
    delete logout_url
    get admin_messages_url
    assert_redirected_to root_path
  end
end
