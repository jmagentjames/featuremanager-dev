require "test_helper"

class MessagesControllerTest < ActionDispatch::IntegrationTest
  teardown do
    Message.delete_all
  end

  test "contact form renders" do
    get new_message_url
    assert_response :success
  end

  test "submit valid message redirects to home" do
    assert_difference "Message.count", 1 do
      post messages_url, params: { message: { name: "Alice", email: "alice@example.com",
                                               body: "Hello, this is a test message!" } }
    end
    assert_redirected_to root_url
  end

  test "submit message with missing fields fails" do
    post messages_url, params: { message: { name: "", email: "", body: "" } }
    assert_response :unprocessable_entity
    # Can't assert count==0 here since other tests create messages
  end
end
