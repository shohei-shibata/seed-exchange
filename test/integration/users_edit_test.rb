require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @invalid_user = { name: "",
                     email: "foo@invalid",
                     password:  "foo",
                     password_confirmation: "bar" }
    @valid_user = { name: "Foo Bar",
                    email: "foo@valid.com",
                    password:  "",
                    password_confirmation: "" }

  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: @invalid_user }
    assert_template 'users/edit'
    assert_select "div.alert", text: "The form contains 4 errors."
  end

  test "successful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: @valid_user }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @valid_user[:name], @user.name
    assert_equal @valid_user[:email], @user.email
  end

  test "successfl edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    patch user_path(@user), params: { user: @valid_user }
    assert_not flash.empty?
    assert_redirected_to @user
    assert_nil session[:forwarding_url]
    @user.reload
    assert_equal @valid_user[:name], @user.name
    assert_equal @valid_user[:email], @user.email
  end
end
