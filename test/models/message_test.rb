require "test_helper"

class MessageTest < ActiveSupport::TestCase
  def setup
    super
    Message.delete_all
  end

  test "valid message saves" do
    msg = Message.new(name: "Alice", email: "alice@example.com", body: "Hello world!")
    assert msg.save
  end

  test "invalid without name" do
    msg = Message.new(name: "", email: "alice@example.com", body: "Hello")
    assert_not msg.save
    assert_includes msg.errors[:name], "can't be blank"
  end

  test "invalid without email" do
    msg = Message.new(name: "Alice", email: "", body: "Hello")
    assert_not msg.save
  end

  test "invalid with short body" do
    msg = Message.new(name: "Alice", email: "alice@example.com", body: "Hi")
    assert_not msg.save
    assert msg.errors[:body].any? { |e| e.include?("too short") }
  end

  test "unread scope only returns unread" do
    msg = Message.create!(name: "Alice", email: "alice@example.com", body: "Hello world!")
    assert_equal 1, Message.unread.count
    msg.update!(is_read: true)
    assert_equal 0, Message.unread.count
  end

  test "default is_read is false" do
    msg = Message.create!(name: "Alice", email: "alice@example.com", body: "Hello world!")
    assert_not msg.is_read?
  end
end
