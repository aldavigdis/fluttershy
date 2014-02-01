class UsersController < ApplicationController
  
  def index
    @company = Company.find(params[:company_id])
  end
  
  def new
    @company = Company.find(params[:company_id])
  end
  
end
