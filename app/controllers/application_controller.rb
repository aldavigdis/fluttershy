# Todo: Move reusable things into Flutter.rb
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  helper_method :nav_item
  helper_method :nav_item_sidebar
  
  # Public: Create a Bootstrap-compatable navigation item for the top nav
  #
  # text        - The link text
  # url         - The link url
  # controller  - The name of the controller associated with the link
  # forceActive - Force the link to have an 'active' state
  def nav_item(text, url, controller=nil, forceActive=nil)
    if forceActive == true
      css_class = 'active'
    else
      
      # The link is usually considered to be 'active' when it links to the
      # current controller
      if params[:controller] == controller
        css_class = 'active'
      end
      
      # There are special rules about the 'active' state for the 'companies
      # and 'users' controllers, because 'users' is a sub-model of 'companies'
      if controller == 'companies'
        if params[:company_id] && params[:company_id].to_i ==
          Flutter::CurrentUser.company
            css_class = ''
        else
          css_class = 'active'
        end
      elsif controller == 'users'
        if params[:company_id] && params[:company_id].to_i ==
          Flutter::CurrentUser.company
            css_class = 'active'
        else
          css_class = ''
        end
      end
      
    end
    
    return %(
      <li class="#{css_class}"><a href="#{url.to_s}">#{text.to_s}</a></li>
    )
  end
  
  # Public: Create a Bootstrap-compatable navigation item for sidebar nav
  #
  # text       - The link text
  # url        - The link url
  # controller - The name of the controller associated with the link
  # icon       - The Glyphicon to use for the navigation element
  def nav_item_sidebar(text, url, controller=nil, active=nil, icon=nil)
    if active == true
      css_class = 'active'
    end
    
    if icon
      link_string = %(<li class="#{css_class}"><a href="#{url.to_s}"><span class="glyphicon glyphicon-#{icon} pull-right"></span>#{text.to_s}</a></li>)
    else
      link_string = %(<li class="#{css_class}"><a href="#{url.to_s}">#{text.to_s}</a></li>)
    end
    
    return link_string
  end
  
  # Public: Create a base-36 random password seed based on a 512-bit hex string
  #
  # Examples
  #
  #   password_seed
  #   => "2yvw1dt2cin418ekaevykylf69o8guk4ccq1by9mmn8sgr4ajr"
  def password_seed
    return SecureRandom.hex(n=32).to_i(16).to_s(36)
  end
  
  # Public: Create a password hash using Whirlpool
  #
  # password - The password to encrypt
  # seed     - The password seed
  #
  # Examples
  #
  #   password_hash "hunter2", "hash"
  #   => "611e3e8a01686f74791dc7e08c9afb761a309ce96642b45d77d41ca4849b435aa8f82f
  #   3ac843e8447785f122630e1d39afea78b6b74ffd0e5017096fc580a293"
  #
  # Returns a hash based on the password and seed, a 512-bit string
  def password_hash(password, seed)
    return Digest::Whirlpool.hexdigest(password+seed)
  end
  
  # Public: Get the correct start/home path based on the user's access level
  def login_startpath(access)
    case session[:user_access]
    when 0..2
      return company_path(session[:company_id])
    when 3..4
      return companies_path      
    end
  end
  
  # Public: Render a 403 Forbidden error
  def access_denied
    render(
      :file => File.join(Rails.root, 'public/403.html'), :status => 403,
      :layout => false
    )
  end
    
end
