require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    @user = users(:vesemir)
  end
  
  test "unsuccessfull edit" do
    log_in_as(@user)
    get edit_user_path(@user, remember_me: '1')
    #@user.reload
    assert_template 'users/edit'
    patch user_path params: { user: { name: "", email: "invalidMail@mail", password: "bar" , password_confirmation: "foo" } }
    @user.reload
    assert_not_equal @user.email, 'invalidMail@mail'
    assert_template 'users/edit'
  end
  
  
  test "successfull edit" do
    log_in_as(@user, remember_me: '1')
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path params: { user: {name: "Foo Bar", email: "foo@bar.com", password: "password" , password_confirmation: "password" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name, "Foo Bar"
    assert_equal @user.email, "foo@bar.com"
  end
=begin  
  test "successfull edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user, remember_me: '1')
    assert_redirected_to edit_user_path(@user)
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path params: { user: {name: name, email: email, password: "password", password_confirmation: "password" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name, name
    assert_equal @user.email, email
  end
=end    
end
