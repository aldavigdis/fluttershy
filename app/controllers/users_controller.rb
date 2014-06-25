class UsersController < ApplicationController
  
  # Include the Flutter library
  require "Flutter"
  
  # Public: List users assigned to the current company
  def index
    @company = Company.find(params[:company_id])
    Flutter::CurrentUser.init_data({
      access: session[:user_access],
      company: session[:company_id]
    })
    
    # Restricted to admin of company and superuser
    access_ok = (Flutter::CurrentUser.is_admin &&
    (@company.id == Flutter::CurrentUser.company)) ||
    Flutter::CurrentUser.is_least_superuser
    
    if access_ok
      @user_access_levels = Flutter::Access.levels
      render_exceptions = [:comments, :password_hash, :password_seed,
        :recovery_code, :recovery_expires, :remember_hash, :company_id]
      
      respond_to do |format|
        format.html
        format.json { render json: @company.users, except: render_exceptions }
        format.xml { render xml: @company.users, except: render_exceptions }
      end
    else
      access_denied
    end
  end
  
  # Public: Form to create and assign user to the current company
  def new
    @company = Company.find(params[:company_id])
    Flutter::CurrentUser.init_data({
      access: session[:user_access],
      company: session[:company_id]
    })
    
    access_ok = (Flutter::CurrentUser.is_admin &&
    (@company.id == Flutter::CurrentUser.company)) ||
    Flutter::CurrentUser.is_superadmin
    
    if access_ok
      @user = @company.users.build
      @user.enabled = true
      
      @user_access_levels = Flutter::Access.levels
      @user_access_levels_available =
      Flutter::Access.new_user_access_levels(session[:user_access])
    else
      access_denied
    end
  end
  
  # Public: Form to edit a user assigned to the current company
  def edit
    @company = Company.find(params[:company_id])
    @user = User.find(params[:id])
    Flutter::CurrentUser.init_data({
      access: session[:user_access],
      company: session[:company_id]
    })
    if ((session[:user_access] == 2) &&
      (@company.id == session[:company_id]) &&
      session[:user_access] >= @user.access) || session[:user_access] == 4
        @user_access_levels = Flutter::Access.levels
        @user_access_levels_available =
        Flutter::Access.new_user_access_levels(session[:user_access])
    else
      access_denied
    end
  end
  
  # Public: Update a user
  def update
    @company = Company.find(params[:company_id])
    Flutter::CurrentUser.init_data({
      access: session[:user_access],
      company: session[:company_id]
    })
    @user = User.find(params[:id])
    if (session[:user_access] == 2 && @company.id == session[:company_id] &&
      session[:user_access] >= @user.access) || session[:user_access] == 4
      
      user_seed = password_seed
      user_hash = password_hash(params[:user]["password"], user_seed)
      
      if session[:user_access] >= params[:user]["access"].to_i
        @user.update_attributes(:access => params[:user]["access"],
        :enabled => params[:user]["access"])
        @user.save
      end
      
      if params[:user]["password"].present?
        @user.update_attributes(:password_hash => user_hash,
        :password_seed => user_seed)
        @user.save
      end
      
      if @user.update(params[:user].permit(:fullname, :email, :enabled))
        redirect_to company_users_path(@company)
      else
        render "edit"
      end
      
    else
      access_denied
    end
  end
  
  # Public: Create a user
  def create
    @company = Company.find(params[:company_id])
    Flutter::CurrentUser.init_data({
      access: session[:user_access],
      company: session[:company_id]
    })
    
    # Access is restricted to admin of company and superadmin
    access_ok = (Flutter::CurrentUser.is_admin &&
    (@company.id == Flutter::CurrentUser.company)) ||
    @company.id == Flutter::CurrentUser.is_superadmin
    
    if access_ok
      @user = User.new(user_params)
    
      user_seed = password_seed
      user_hash = password_hash(params[:user]["password"], user_seed)
    
      @user.update_attributes(password_hash: user_hash,
      password_seed: user_seed, company_id: params[:company_id],
      enabled: params[:user]["enabled"])
    
      if @user.save
        redirect_to company_users_path(@company)
      else
        render "new"
      end
    else
      access_denied
    end
  end
  
  # Public: Show a user
  def show
    @company = Company.find(params[:company_id])
    Flutter::CurrentUser.init_data({
      access: session[:user_access],
      company: session[:company_id]
    })
    
    @user = User.find(params[:id])
    
    # Access is restricted to superuser, superadmin, admin and self
    access_ok = Flutter::CurrentUser.is_least_superuser ||
      (Flutter::CurrentUser.is_admin && (@user.company_id == Flutter::CurrentUser.company)) ||
      (session[:user_id] == @user.id)
    
    if access_ok
      render_exceptions = [:comments, :password_hash, :password_seed,
        :recovery_code, :recovery_expires, :remember_hash]
      @user_access_levels = Flutter::Access.levels
      respond_to do |format|
        format.html { render html: @user, except: render_exceptions }
        format.json { render json: @user, except: render_exceptions }
        format.xml { render xml: @user, except: render_exceptions }
      end
    else
      access_denied
    end
  end
  
  def destroy
    @company = Company.find(params[:company_id])
    Flutter::CurrentUser.init_data({
      access: session[:user_access],
      company: session[:company_id]
    })
    
    @user = User.find_by(id: params[:id], company_id: params[:company_id])
    if (((session[:user_access] == 2) &&
      (@company.id == session[:company_id]) &&
        session[:user_access] >= @user.access) ||
        session[:user_access] == 4) && @user.id != session[:user_id]
      @user.destroy
      redirect_to company_users_path(@company)
    else
      access_denied
    end
  end
  
  # Public: Show the edit_password view
  # Todo: Finish this
  def edit_password
    @company = Company.find(params[:company_id])
    @user = User.find(params[:id])
    Flutter::CurrentUser.init_data({
      access: session[:user_access],
      company: session[:company_id]
    })
    if Flutter::CurrentUser.is_user && (params[:id].to_i == session[:user_id])
      render "edit_password"
    else
      access_denied
    end
  end
  
  # Public: Submit the new password from edit_password
  # Todo: Finish this
  def update_password
    @company = Company.find(params[:company_id])
    @user = User.find(params[:id])
    Flutter::CurrentUser.init_data({
      access: session[:user_access],
      company: session[:company_id]
    })
    if Flutter::CurrentUser.is_user && (params[:id].to_i == session[:user_id])
      render "show"
    else
      access_denied
    end
  end
  
  # Public: List a users's login attempts
  def logins
    @company = Company.find(params[:company_id])
    @user = User.find(params[:id])
    Flutter::CurrentUser.init_data({
      access: session[:user_access],
      company: session[:company_id]
    })
    # Access is restricted to superadmin
    access_ok = Flutter::CurrentUser.is_superadmin
    respond_to do |format|
      format.html { render html: @user.logins }
      format.json { render json: @user.logins }
      format.xml { render xml: @user.logins }
    end
  end
  
  private
  def user_params
    params.require(:user).permit(:fullname, :email, :password_hash,
      :password_seed, :access, :company_id)
  end
  
end
