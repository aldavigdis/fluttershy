class CompaniesController < ApplicationController
  
  def index
    @companies = Company.all
  end
  
  def new
    @company = Company.new
  end
  
  def create
    @company = Company.new(company_params)
    if @company.save
      redirect_to @company
    else
      render "new"
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
  end
  
  def update
    @company = Company.find(params[:id])
    if @company.update(params[:company].permit(
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
      :enabled,
      :comments
    ))
      redirect_to @company
    else
      render "edit"
    end
  end
  
  def destroy
    @company = Company.find(params[:id])
    @company.destroy 
    
    redirect_to companies_path
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
