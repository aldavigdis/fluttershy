class UsersController < ApplicationController
    
  def index
    @company = Company.find(params[:company_id])
    if ((session[:user_access] == 2) && (@company.id == session[:company_id])) || session[:user_access] == 3 || session[:user_access] == 4
      @user_access_levels = user_access_levels
    else
      access_denied
    end
  end
  
  def new
    @company = Company.find(params[:company_id])
    @user = @company.users.build
    if ((session[:user_access] == 2) && (@company.id == session[:company_id])) || session[:user_access] == 4
      @user_access_levels = user_access_levels
      @user_access_levels_available = user_access_levels_available(session[:user_access])
    else
      access_denied
    end
  end
  
  def edit
    @company = Company.find(params[:company_id])
    @user = User.find(params[:id])
    if ((session[:user_access] == 2) && (@company.id == session[:company_id]) && session[:user_access] >= @user.access) || session[:user_access] == 4
      @user_access_levels = user_access_levels
      @user_access_levels_available = user_access_levels_available(session[:user_access])
    else
      access_denied
    end
  end
  
  def update
    @company = Company.find(params[:company_id])
    if ((session[:user_access] == 2) && (@company.id == session[:company_id]) && session[:user_access] >= @user.access) || session[:user_access] == 4
      
      @user = User.find(params[:id])
      user_seed = password_seed
      user_hash = password_hash(params[:user]["password"], user_seed)
      
      if session[:user_access] >= params[:user]["access"].to_i
        @user.update_attributes(:access => params[:user]["access"], :enabled => params[:user]["access"])
        @user.save
      end
      
      if params[:user]["password"].present?
        @user.update_attributes(:password_hash => user_hash, :password_seed => user_seed)
        @user.save
      end
      
      if @user.update(params[:user].permit(:fullname, :email))
        redirect_to company_users_path(@company)
      else
        render "edit"
      end
      
    else
      access_denied
    end
  end
  
  def create
    @company = Company.find(params[:company_id])
    @user = User.new(user_params)
    @user_access_levels = user_access_levels
    @user_access_levels_available = user_access_levels_available(session[:user_access])
    
    user_seed = password_seed
    user_hash = password_hash(params[:user]["password"], user_seed)
    
    @user.update_attributes(:password_hash => user_hash, :password_seed => user_seed, :company_id => params[:company_id])
    
    if @user.save
      redirect_to company_users_path(@company)
    else
      render "new"
    end
  end
  
  def show
    @company = Company.find(params[:company_id])
    @user = User.find(params[:id])
    @user_access_levels = user_access_levels
  end
  
  def destroy
    @company = Company.find(params[:company_id])
    @user = User.find_by(id: params[:id], company_id: params[:company_id])
    if (((session[:user_access] == 2) && (@company.id == session[:company_id]) && session[:user_access] >= @user.access) || session[:user_access] == 4) && @user.id != session[:user_id]
      @user.destroy
      redirect_to company_users_path(@company)
    else
      access_denied
    end
  end
  
  private
  def user_params
    params.require(:user).permit(:fullname, :email, :password_hash, :password_seed, :access, :company_id)
  end
  
end
