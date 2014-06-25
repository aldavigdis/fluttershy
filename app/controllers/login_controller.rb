# Public: The login controller.
class LoginController < ApplicationController
  
  layout "login", only: [:index]
  
  # Public: Register login attempt in the database.
  #
  # user_id - The user's ID
  # success - Boolean value for login success or failure
  #
  # Logins older than 6 monts can be cleared by running 'rake delete:old_logins'
  # — This should be set up as a Cron job and run every day to comply vith EU
  # privacy regulations.
  #
  # Returns true on success, false on falure.
  def login_register(user_id, success)
    ip_addr = IPAddr.new(request.remote_ip).to_i
    useragent = request.env['HTTP_USER_AGENT']
    this_login = Login.new
    this_login.update_attributes(
      :user_id => user_id, :ip_addr => ip_addr, :useragent => useragent,
      :success => success)
    return this_login.save
  end
  
  # Public: Log the user out
  #
  # Log the user out by clearing cookies and session data, and then redirect
  # to the root.
  def logout
    reset_session
    cookies.permanent.signed[:remember_user_id] = nil
    cookies.permanent.signed[:remember_user_token] = nil
    redirect_to root_path
  end
  
  # Public: Process requests and render the main view
  def index
    
    # Check if user is already logged in
    if session[:user_id]
      redirect_to login_startpath(session[:user_access])
      
    # If not, check if user is logging in right now
    elsif params[:email] && params[:password]
      sleep 1
      check_user = User.find_by(email: params[:email])
      if check_user
        password_hash = password_hash(params[:password], check_user.password_seed)
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
    
    # If not, check if user has a saved session
    elsif cookies.permanent.signed[:remember_user_id] && cookies.permanent.signed[:remember_user_token]
      check_user = User.find(cookies.permanent.signed[:remember_user_id])
      check_hash = Digest::Whirlpool.hexdigest(cookies.permanent.signed[:remember_user_token] + check_user.password_seed)
      if check_user.remember_hash == check_hash
        login_ok = true
        login_user = check_user
      else
        login_ok = false
        @login_error = "Saved user credentials do not match"
        sleep 2
      end
    end
    
    # Proceed with the login if everything checks out
    if login_ok === true
      
      # Register the login attempt
      login_register(check_user.id, login_ok)
      
      # Set session variables
      session[:user_id] = login_user.id
      session[:user_fullname] = login_user.fullname
      session[:user_email] = login_user.email
      session[:user_access] = login_user.access
      session[:company_id] = login_user.company_id
      
      # Check if the user wanted the session to be saved.
      if params[:remember] == true
        
        # The password_seed method is used to generate the stored token.
        # The remember_token is then stored as a signed cookie along with the
        # user's ID from the database.
        remember_token = password_seed
        cookies.permanent.signed[:remember_user_id] = login_user.id
        cookies.permanent.signed[:remember_user_token] = remember_token
        
        # The WHIRLPOOL hash of remember_token and the user's password seed is
        # then stored in the database.
        remember_hash = Digest::Whirlpool.hexdigest(remember_token+login_user.password_seed)
        login_user.update_attributes(:remember_hash => remember_hash)
        login_user.save
      end
      
      # Redirect to the correct view
      redirect_to login_startpath(login_user.access)
    end
  end
    
end
