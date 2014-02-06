class CompaniesController < ApplicationController
  
  def index
    if session[:user_access] == 3 || session[:user_access] == 4
      @companies = Company.all
    else
      access_denied
    end
  end
  
  def new
    @company = Company.new
    if session[:user_access] == 4
    else
      access_denied
    end
  end
  
  def create
    if session[:user_access] == 4
      @company = Company.new(company_params)
      if @company.save
        redirect_to @company
      else
        render "new"
      end
    else
      access_denied
    end
  end
  
  def show
    @company = Company.find(params[:id])
    @company_has_billing_address = false
    @company_has_shipping_address = false
    
    if @company.address1.present? || @company.address2.present? || @company.postcode.present? || @company.city.present?
      @company_has_billing_address = true
    end
    
    if @company.shipping_address1.present? || @company.shipping_address2.present? || @company.shipping_postcode.present? || @company.shipping_city.present?
      @company_has_shipping_address = true
    end
    
  end
  
  def edit
    @company = Company.find(params[:id])
    if (session[:user_access] == 2 && session[:company_id] == @company.id) || session[:user_access] == 4
    else
      access_denied
    end
  end
  
  def update
    @company = Company.find(params[:id])
    if session[:user_access] == 4
      access_ok = true
      company_update = @company.update(params[:company].permit(:name, :kt, :email, :tel, :mobile, :fax, :contact_name, :comments, :address1, :address2, :postcode, :city, :shipping_address1, :shipping_address2, :shipping_postcode, :shipping_city, :enabled, :comments))
    elsif session[:user_access] == 2 && session[:company_id] == @company.id
      access_ok = true
      company_update = @company.update(params[:company].permit(:email, :tel, :mobile, :fax, :contact_name, :comments, :address1, :address2, :postcode, :city, :shipping_address1, :shipping_address2, :shipping_postcode, :shipping_city))
    end
    
    if access_ok
      if company_update
        redirect_to @company
      else
        render "edit"
      end
    else
      access_denied
    end
    
  end
  
  def destroy
    @company = Company.find(params[:id])
    if session[:user_access] == 4
      if @company.id == session[:company_id]
        @companies = Company.all
        @error = "You cannot erase your own company"
        redirect_to companies_path
      else
        @company.destroy 
        redirect_to companies_path
      end
    else
      access_denied
    end
  end
  
  private
  def company_params
    params.require(:company).permit(
    :name,
    :kt,
    :email,
    :tel,
    :mobile,
    :fax,
    :contact_name,
    :comments,
    :address1,
    :address2,
    :postcode,
    :city,
    :shipping_address1,
    :shipping_address2,
    :shipping_postcode,
    :shipping_city,
    :comments,
    :enabled
    )
  end
end
