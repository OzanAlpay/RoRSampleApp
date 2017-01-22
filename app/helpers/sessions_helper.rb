module SessionsHelper
  
  def log_in(user)
    session[:user_id] = user.id
  end
  
  def current_user
    if(user_id = session[:user_id]) #Be aware that it is not an check(not ==) , it is an assignment
      #print "Session is not null , current user id is = " , session[:user_id]
      #print "current user get from session"
      @current_user ||= User.find_by(id: session[:user_id])
    elsif(user_id = cookies.signed[:user_id])
      #print "Session id is null"
      #print "current user get from cookies"
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
        @current_user
      else
        #print "current user from cookies authentication error"
      end
    else
      #print "current user error"
    end
  end
  
  def logged_in?
    !current_user.nil? #If current_user function returns nil or not?
  end
  
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
  
  def remember(user)
    #current_user
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
    #Be aware !:remember_token didn't saved with signed attribute.
  end
  
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  
  def current_user?(user)
    user == current_user
  end
  
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end
  
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
    
  
end
