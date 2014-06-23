class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  helper_method :nav_item
  helper_method :nav_item_sidebar
  
  def nav_item(text, url, controller=nil, forceActive=nil)
    if forceActive == true
      css_class = 'active'
    else
      
      if params[:controller] == controller
        css_class = 'active'
      end
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
  
  def password_seed
    return SecureRandom.hex(n=32).to_i(16).to_s(36)
  end
  
  def password_hash(password, seed)
    return Digest::Whirlpool.hexdigest(password+seed)
  end
  
  def login_startpath(access)
    case session[:user_access]
    when 0..2
      return company_path(session[:company_id])
    when 3..4
      return companies_path      
    end
  end
  
  def access_denied
    render(
      :file => File.join(Rails.root, 'public/403.html'), :status => 403,
      :layout => false
    )
  end
    
end
