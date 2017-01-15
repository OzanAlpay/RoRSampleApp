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
  
  test "login with valid information followed by logout" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: @user.email, password: "password"} }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    delete logout_path
    follow_redirect!
  end
  
  test "login with remember" do
    log_in_as(@user, remember_me: '1')
=begin
    puts "Cookies user id is = ", cookies['user_id']
    puts "User id = ", assigns(:user).id
    puts "Cookies remember token is = ", cookies['remember_token']
    puts "Cookies remember token after digest op is = ", User.digest(cookies['remember_token'])
    rem_dig = assigns(:user).remember_digest
    rem_tok = assigns(:user).remember_token
    puts "User remember_digest = ", rem_dig
    puts "User remember_digest digest = " , User.digest(rem_dig)
    puts "User remember_token = " , rem_tok
    puts "User remember_token digest = ", User.digest(rem_tok)
=end
    assert_equal User.digest(cookies['remember_token']), assigns(:user).remember_digest
  end
  
  test "login without remember" do
    log_in_as(@user, remember_me: '1')
    log_in_as(@user, remember_me: '0')
    assert_nil cookies['remember_token']
  end
  
end