require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should not save user without email" do
    user = User.new(password: "password123")
    assert_not user.save, "Saved the user without an email address"
  end

  test "should not save user with invalid email format" do
    user = User.new(email_address: "invalid-email", password: "password123")
    assert_not user.save, "Saved the user with invalid email format"
  end

  test "should save user with valid attributes" do
    user = User.new(
      email_address: "test@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    assert user.save, "Could not save the user with valid attributes"
  end

  test "should not save user with short password" do
    user = User.new(email_address: "test@example.com", password: "short")
    assert_not user.save, "Saved the user with a password shorter than 6 characters"
  end

  test "should not save user with duplicate email" do
    User.create!(
      email_address: "duplicate@example.com",
      password: "password123",
      password_confirmation: "password123"
    )

    duplicate_user = User.new(
      email_address: "duplicate@example.com",
      password: "password123"
    )
    assert_not duplicate_user.save, "Saved user with duplicate email address"
  end

  test "should normalize email address" do
    user = User.new(
      email_address: "  TEST@EXAMPLE.COM  ",
      password: "password123",
      password_confirmation: "password123"
    )
    user.save
    assert_equal "test@example.com", user.email_address
  end
end
