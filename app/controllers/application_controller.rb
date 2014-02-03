class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  def user_access_levels
    return { User: 0, Kiosk: 1, Admin: 2, Superuser: 3, Superadmin: 4 }
  end
  
  def password_seed
    return SecureRandom.hex(n=32).to_i(16).to_s(36)
  end
  
  def password_hash(password, seed)
    return Digest::Whirlpool.hexdigest(password+seed)
  end
  
  def login_startpath(access)
    return companies_path
  end
    
end
