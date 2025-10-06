require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      email_address: "test@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
  end

  test "should get login page" do
    get new_session_url
    assert_response :success
  end

  test "should login with valid credentials" do
    post session_url, params: {
      email_address: "test@example.com",
      password: "password123"
    }
    assert_redirected_to root_url
  end

  test "should not login with invalid password" do
    post session_url, params: {
      email_address: "test@example.com",
      password: "wrongpassword"
    }
    assert_redirected_to new_session_url
    follow_redirect!
    assert_match "Try another email address or password", response.body
  end

  test "should logout" do
    # First login
    post session_url, params: {
      email_address: "test@example.com",
      password: "password123"
    }

    # Then logout
    delete session_url
    assert_redirected_to new_session_url
  end
end
