require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  valid_user = { name: "Valid User", 
                 email: "user@invalid.com",
                 password: "foobar",
                 password_confirmation: "foobar" }
  invalid_user = { name: "", 
                   email: "user@invalid",
                   password: "foo",
                   password_confirmation: "bar" }

  test "valid signup information" do
    get signup_path
    assert_response :success
    assert_difference 'User.count', 1 do
      post users_path, params: { user: valid_user }
    end
    follow_redirect!
    assert_template 'users/show'                               
    assert_select 'div.alert-success'
  end
  test "invalid signup information" do
    get signup_path
    assert_response :success
    assert_no_difference 'User.count' do
      post users_path, params: { user: invalid_user }
    end
    assert_template 'users/new'                               
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end
end
