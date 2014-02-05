class CompaniesController < ApplicationController
  
  def index
    if session[:user_access] == 3 || session[:user_access] == 4
      @companies = Company.all
    else
      access_denied
    end
  end
  
  def new
    if session[:user_access] == 4
      @company = Company.new
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
    if (
      ( ((@company.address1).nil? || (@company.address1).empty?) == false ) ||
      ( ((@company.address2).nil? || (@company.address2).empty?) == false ) ||
      ( ((@company.postcode).nil? || (@company.postcode).empty?) == false ) ||
      ( ((@company.city).nil? || (@company.city).empty?) == false )
    )
      @company_has_billing_address = true
    end
    if (
      ( ((@company.shipping_address1).nil? || (@company.shipping_address1).empty?) == false ) ||
      ( ((@company.shipping_address2).nil? || (@company.shipping_address2).empty?) == false ) ||
      ( ((@company.shipping_postcode).nil? || (@company.shipping_postcode).empty?) == false ) ||
      ( ((@company.shipping_city).nil? || (@company.shipping_city).empty?) == false )
    )
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
      company_update = @company.update(params[:company].permit(:name, :kt, :email, :tel, :mobile, :fax, :contact_name, :comments, :address1, :address2, :postcode, :city, :shipping_address1, :shipping_address2, :shipping_postcode, :shipping_city, :enabled, :comments))
      if company_update
        redirect_to @company
      else
        render "edit"
      end
    elsif session[:user_access] == 2 && session[:company_id] == @company.id
      company_update = @company.update(params[:company].permit(:email, :tel, :mobile, :fax, :contact_name, :comments, :address1, :address2, :postcode, :city, :shipping_address1, :shipping_address2, :shipping_postcode, :shipping_city))
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
    if session[:user_access] == 4
      @company = Company.find(params[:id])
      @company.destroy 
      redirect_to companies_path
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
