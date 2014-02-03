class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  def user_access_levels
    return { User: 0, Kiosk: 1, Admin: 2, Superuser: 3, Superadmin: 4 }
  end
  
  def user_access_levels_available(access)
    if access >= 2
      output_hash = {}
      user_access_levels.each do |key,value|
        if value <= access
          output_hash[key] = value
        end
      end
      return output_hash
    else
      return {}
    end
  end
  
  def password_seed
    return SecureRandom.hex(n=32).to_i(16).to_s(36)
  end
  
  def password_hash(password, seed)
    return Digest::Whirlpool.hexdigest(password+seed)
  end
  
  def login_startpath(access)
    case session[:user_access]
    when 0
      company_path(session[:company_id])
    when 1
      company_path(session[:company_id])
    when 2
      company_path(session[:company_id])
    when 3..4
      return companies_path      
    end
  end
  
  def access_denied
    render(:file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false)
  end
  
  def user_access
    check_user = User.find(session[:user_id])
    return check_user.access
  end
    
end
