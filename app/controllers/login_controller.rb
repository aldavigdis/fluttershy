class LoginController < ApplicationController
  
  layout "login", only: [:index]
  
  def index
    
    # Check if user is already logged in
    if session[:user_id]
      redirect_to login_startpath(session[:user_access])
      
    # Check if user is logging in right now
    elsif params[:email] && params[:password]
      sleep 1
      check_user = User.find_by(email: params[:email])
      if check_user
        password_hash = password_hash(params[:password],check_user.password_seed)
        puts password_hash
        if check_user.password_hash == password_hash
          login_ok = true
          login_user = check_user
        else
          login_ok = false
          @login_error = "Invalid username or password"
          sleep 2
        end
      else
        login_ok = false
        @login_error = "Invalid username or password"
        sleep 2
      end
    
    # Check if user has a saved session
    elsif cookies.permanent.signed[:remember_user_id] && cookies.permanent.signed[:remember_user_token]
      check_user = User.find(cookies.permanent.signed[:remember_user_id])
      check_hash = Digest::Whirlpool.hexdigest(cookies.permanent.signed[:remember_user_token]+check_user.password_seed)
      if check_user.remember_hash == check_hash
        login_ok = true
        login_user = check_user
      else
        login_ok = false
        @login_error = "Saved user credentials do not match"
        sleep 2
      end
    end
    
    if login_ok === true
      
      # Set session variables
      session[:user_id] = login_user.id
      session[:user_fullname] = login_user.fullname
      session[:user_email] = login_user.email
      session[:user_access] = login_user.access
      session[:company_id] = login_user.company_id
      
      # Check if the user wanted the session to be saved
      if params[:remember]
        # The password_seed method is used to generate the stored token
        remember_token = password_seed
        # The token is stored as a signed cookie
        cookies.permanent.signed[:remember_user_id] = login_user.id
        cookies.permanent.signed[:remember_user_token] = remember_token
        # The WHIRLPOOL hash of password_seed and the user's password seed is stored in database
        remember_hash = Digest::Whirlpool.hexdigest(remember_token+login_user.password_seed)
        login_user.update_attributes(:remember_hash => remember_hash)
        login_user.save
      else
        login_user.update_attributes(:remember_hash => nil)
        login_user.save
      end
      
      # Redirect to the correct view
      redirect_to login_startpath(login_user.access)
    end
  end
  
  def logout
    reset_session
    cookies.permanent.signed[:remember_user_id] = nil
    cookies.permanent.signed[:remember_user_token] = nil
    redirect_to root_path
  end
    
end
