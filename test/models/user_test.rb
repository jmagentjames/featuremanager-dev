require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "valid user saves" do
    user = User.new(name: "Alice", email: "alice_#{SecureRandom.hex}@example.com",
                    password: "password123", password_confirmation: "password123")
    assert user.save
  end

  test "invalid without name" do
    user = User.new(name: "", email: "alice@example.com", password: "password123", password_confirmation: "password123")
    assert_not user.save
    assert_includes user.errors[:name], "can't be blank"
  end

  test "email is normalized to lowercase" do
    hex = SecureRandom.hex
    user = User.create!(name: "Alice", email: "  ALICE_#{hex}@EXAMPLE.COM  ",
                        password: "password123", password_confirmation: "password123")
    assert_equal "alice_#{hex}@example.com", user.email
  end

  test "has_secure_password works" do
    user = User.create!(name: "Alice", email: "alice_#{SecureRandom.hex}@example.com",
                        password: "password123", password_confirmation: "password123")
    assert user.authenticate("password123")
    assert_not user.authenticate("wrong")
  end

  test "admin scope returns admins" do
    User.create!(name: "Admin", email: "admin_#{SecureRandom.hex}@example.com",
                 password: "password123", password_confirmation: "password123", admin: true)
    assert_equal 1, User.admins.count
  end

  test "generate_reset_password_token sets fields" do
    user = User.create!(name: "Alice", email: "alice_#{SecureRandom.hex}@example.com",
                        password: "password123", password_confirmation: "password123")
    token = user.generate_reset_password_token
    assert_not_nil user.reset_password_token
    assert_not_nil user.reset_password_sent_at
    assert_not user.reset_password_token_expired?
  end

  test "clear_reset_password_token clears fields" do
    user = User.create!(name: "Alice", email: "alice_#{SecureRandom.hex}@example.com",
                        password: "password123", password_confirmation: "password123")
    user.generate_reset_password_token
    user.clear_reset_password_token
    assert_nil user.reset_password_token
    assert_nil user.reset_password_sent_at
  end
end
