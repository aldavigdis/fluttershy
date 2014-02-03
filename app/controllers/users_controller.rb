class UsersController < ApplicationController
    
  def index
    @company = Company.find(params[:company_id])
    @user_access_levels = user_access_levels
  end
  
  def new
    @company = Company.find(params[:company_id])
    @user = User.new
    @user_access_levels = user_access_levels
  end
  
  def edit
    @company = Company.find(params[:company_id])
    @user = User.find(params[:id])
    @user_access_levels = user_access_levels
  end
  
  def update
    @company = Company.find(params[:company_id])
    @user = User.find(params[:id])
    
    user_seed = password_seed
    user_hash = password_hash(params[:user]["password"], user_seed)
    
    if params[:user]["password"].present?
      @user.update_attributes(:password_hash => user_hash, :password_seed => user_seed)
      @user.save
    end
    
    if @user.update(params[:user].permit(:fullname, :email))
      redirect_to company_users_path(@company)
    else
      render "edit"
    end
  end
  
  def create
    @company = Company.find(params[:company_id])
    @user = User.new(user_params)
    
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
    @user.destroy
    redirect_to company_users_path(@company)
  end
  
  private
  def user_params
    params.require(:user).permit(:fullname, :email, :password_hash, :password_seed, :access, :company_id)
  end
  
end
