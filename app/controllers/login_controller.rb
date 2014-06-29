# Public: The login controller.
class LoginController < ApplicationController
  
  layout "login", only: [:index]
  
  require "Flutter"
  
  # Logs the user out
  #
  # Logs the user out by clearing cookies and session data, and then redirects
  # to the root path.
  def logout
    user_lookup = User.find_by id: session[:user_id]
    user_lookup.update_attributes(:remember_hash => nil)
    user_lookup.save
    reset_session
    cookies.permanent.signed[:remember_user_id] = nil
    cookies.permanent.signed[:remember_user_token] = nil
    redirect_to root_path
  end
  
  # Processes requests and render the main view
  def index
    
    # Check if user is already logged in according to session data and redirec
    # to the appropriate start path
    if session[:user_id]
      redirect_to login_startpath(session[:user_access])
      
    # If not, check if user is logging in right now
    elsif params[:email] && params[:password]
      user_lookup = User.find_by email: params[:email]
      login_result = check_login user_lookup, params[:password]
      login_success = login_result['success']
      @login_error = login_result['error_text']
      login_register user_lookup.id, login_success
    
    # If not, check if user has a saved session
    elsif cookies.permanent.signed[:remember_user_id] &&
      cookies.permanent.signed[:remember_user_token]
      
      user_lookup = User.find(cookies.permanent.signed[:remember_user_id])
      login_result = check_session user_lookup
      login_success = login_result['success']
      @login_error = login_result['error_text']
      login_register user_lookup.id, login_success
    end
    
    # Proceed with the login if everything checks out
    if login_success == true
      
      # Set session variables
      set_session user_lookup
      
      # Check if the user wanted the session to be saved.
      if params[:remember]
        save_session user_lookup
      end
      
      # Redirect to the correct view
      redirect_to login_startpath(user_lookup.access)
    end
  end
  
  private
  # Register login attempt in the database.
  #
  # @param user_id [Interger, String] The user's ID (primary key)
  # @param success [Boolean] Boolean value for login success or failure
  #
  # Logins older than 6 monts can be cleared by running 'rake delete:old_logins'
  # — This rake task should be set up as a Cron job and run every day to comply
  # vith EU privacy regulations.
  #
  # Returns true on success, false on falure.
  def login_register(user_id, success)
    ip_addr = IPAddr.new(request.remote_ip).to_i
    useragent = request.env['HTTP_USER_AGENT']
    this_login = Login.new
    
    this_login.update_attributes(:user_id => user_id, :ip_addr => ip_addr,
    :useragent => useragent, :success => success)
    
    return this_login.save
  end
  
  # Check a User object for the right password and if it is enabled
  #
  # @param check_user [Object] The user object
  # @param password [String] The password to check
  #
  # @example
  #   user = User.find_by email: params[:email]
  #   password = params[:password]
  #   check_login user, password
  #   => { "success" => false, "error_text" => "User access has been disabled." }
  #
  # @return [Hash] Hash containing info on success and an error message, if any.
  def check_login check_user, password
    password_hash = password_hash password, check_user.password_seed
    if check_user.enabled == false
      return { "success" => false,
        "error_text" => "User access has been disabled." }
    elsif check_user.password_hash == password_hash
      return { "success" => true,
        "error_text" => "Login successful." }
    else
      return { "success" => false,
        "error_text" => "Invalid username or password." }
    end
  end
  
  # Check if the user has already logged in using a permanent cookie
  #
  # @param check_user [Object] The user object to check for
  #
  # @example
  #   user_lookup = User.find(cookies.permanent.signed[:remember_user_id])
  #   check_session user_lookup
  #   => { "success" => true }
  #
  # @return [Hash] Hash based containing info on if the saved login credidentials are correct.
  def check_session check_user
    check_hash = Digest::Whirlpool.hexdigest(
      cookies.permanent.signed[:remember_user_token] + check_user.password_seed)
    if check_user.remember_hash == check_hash
      return { "success" => true }
    else
      return { "success" => false,
        "error_text" => "Saved user credentials do not match" }
    end
  end
  
  # Save the user's info as session variables
  #
  # @param user [Object] The user object
  # @todo Write validation and return boolean value based on it
  def set_session user
    session[:user_id] = user.id
    session[:user_fullname] = user.fullname
    session[:user_email] = user.email
    session[:user_access] = user.access
    session[:company_id] = user.company_id
  end
  
  # Save login credidentials as a permanent cookie
  #
  # @param user [Object] The user object
  # @todo Write validation and return boolean value based on it
  def save_session user
    # The password_seed method is used to generate the stored token.
    # The remember_token is then stored as a signed cookie along with the
    # user's ID from the database.
    remember_token = password_seed
    cookies.permanent.signed[:remember_user_id] = user.id
    cookies.permanent.signed[:remember_user_token] = remember_token
    
    # The WHIRLPOOL hash of remember_token and the user's password seed is
    # then stored in the database.
    remember_hash = Digest::Whirlpool.hexdigest(remember_token +
      user.password_seed)
    user.update_attributes(:remember_hash => remember_hash)
    user.save
  end
    
end
