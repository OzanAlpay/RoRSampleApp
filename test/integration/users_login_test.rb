require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:vesemir)
  end
  
  test "unsuccesfull user login" do
    get login_path
    assert_template 'sessions/new'
    post login_path params: {session: {email: "", password: ""} }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
  
  test "successfull user login" do
    get login_path
    assert_template 'sessions/new'
    post login_path params: { session: {email: @user.email, password: 'password' } }
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end
  
  #TODO apply DRY principle to this test case
  test "successfull login then sign out" do
    get login_path
    assert_template 'sessions/new'
    post login_path params: { session: {email: @user.email, password: 'password' } }
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_path
  end
  
end
