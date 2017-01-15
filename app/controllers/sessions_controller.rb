class SessionsController < ApplicationController
  
  def new
  end
  
  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      log_in @user
      #puts "Params session remember me is = ", params[:session][:remember_me].to_s
      #puts "Params session remember ME is 1 " if params[:session][:remember_me] == "1"
      #puts "Params session remember ME is 0 " if params[:session][:remember_me] == "0"
      params[:session][:remember_me] == "1" ? remember(@user) : forget(@user)
      redirect_to @user
    else
      flash.now[:danger] = "Invalid email/password combination"
      render 'new'
    end
  end
  
  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
