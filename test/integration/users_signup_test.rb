require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @valid_user = { name: "Valid User", 
                   email: "user@invalid.com",
                   password: "foobar",
                   password_confirmation: "foobar" }
    @invalid_user = { name: "", 
                     email: "user@invalid",
                     password: "foo",
                     password_confirmation: "bar" }
  end

  test "valid signup information with account activation" do
    get signup_path
    assert_response :success
    assert_difference 'User.count', 1 do
      post users_path, params: { user: @valid_user }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    # Try to log in before activation.
    log_in_as(user)
    assert_not is_logged_in?
    # Invalid activation token
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    # Valid activation token, wrong email
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # Valid activation token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?

    follow_redirect!
    assert_template 'users/show'                               
    assert_select 'div.alert-success'
    assert is_logged_in?
  end

  test "invalid signup information" do
    get signup_path
    assert_response :success
    assert_no_difference 'User.count' do
      post users_path, params: { user: @invalid_user }
    end
    assert_template 'users/new'                               
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end
end
