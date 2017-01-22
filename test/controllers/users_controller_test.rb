require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get signup_path
    assert_response :success
  end
  
  def setup
    @user = users(:vesemir)
    @second_user = users(:lambert)
  end
  
  test "should redirect edit when not logged in" do
    delete logout_path
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_path
  end
  
  test "should redirect update when not logged in" do
    delete logout_path
    patch user_path(@user), params: { user: { name: @user.name, email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_path
  end
  
  test "should redirect edit when logged in as wrong user" do
    delete logout_path
    log_in_as(@user)
    get edit_user_path(@second_user)
    #assert_not flash.empty?
    assert_redirected_to root_url
  end
  
  test "should redirect update when logged in as wrong user" do
    delete logout_path
    log_in_as(@second_user)
    patch user_path(@user), params: { user: { name: @second_user.name, email: @second_user.email } }
    #assert_not flash.empty?
    assert_redirected_to root_url
  end
  
  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end
  
  test "should not allow update admin attribute via web request" do
    delete logout_path
    log_in_as(@second_user)
    assert_not @second_user.admin?
    patch user_path(@second_user), params: { user: { password: "password" , password_confirmation: "password", admin: true } }
    assert_not @second_user.reload.admin?
  end
  
  test "should redirect destroy when not logged in" do
    assert_no_difference "User.count" do
      delete user_path(@user)
    end
    assert_redirected_to login_path
  end
  
  test "should redirect destroy when logged in as non-admin" do 
    log_in_as(@second_user) # Our non-admin user
    assert_no_difference "User.count" do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end
    

end
