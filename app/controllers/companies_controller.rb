class CompaniesController < ApplicationController
  
  require "Flutter"
  
  def index
    Flutter::CurrentUser.init_data({access: session[:user_access]})
    if Flutter::CurrentUser.is_least_superuser
      if params[:search]
        if params[:search].present?
          @companies = Company.search(name: params[:search])
          respond_to do |format|
            format.html
            format.json { render json: @companies }
          end
        else
          @companies = {}
        end
      else
        respond_to do |format|
          format.html { @companies = Company.paginate(page: params[:page]) }
          format.json { @companies = Company.all; render json: @companies }
        end
      end
    else
      access_denied
    end
  end
  
  def new
    Flutter::CurrentUser.init_data({access: session[:user_access]})
    if Flutter::CurrentUser.is_superadmin
      @company = Company.new
    else
      access_denied
    end
  end
  
  def create
    Flutter::CurrentUser.init_data({access: session[:user_access]})
    if Flutter::CurrentUser.is_superadmin
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
    Flutter::CurrentUser.init_data({
      access: session[:user_access], company: session[:company_id]
    })
    @company = Company.find(params[:id])

    if Flutter::CurrentUser.is_least_superuser ||
      (Flutter::CurrentUser.is_least_user && Flutter::CurrentUser.company ==
      @company.id)

      @company_has_billing_address = false
      @company_has_shipping_address = false

      @company_has_billing_address = @company.address1.present? ||
        @company.address2.present? || @company.postcode.present? ||
        @company.city.present?

      @company_has_shipping_address = @company.shipping_address1.present? ||
        @company.shipping_address2.present? ||
        @company.shipping_postcode.present? || @company.shipping_city.present?
      
      respond_to do |format|
        format.html
        format.json { render json: @company }
      end
      
    else
      access_denied
    end
  end
  
  def edit
    Flutter::CurrentUser.init_data({
      access: session[:user_access], company: session[:company_id]
    })
    @company = Company.find(params[:id])
    
    if !(Flutter::CurrentUser.is_superadmin || (Flutter::CurrentUser.is_admin &&
      Flutter::CurrentUser.company == @company.id))
      access_denied
    end
  end
  
  def update
    Flutter::CurrentUser.init_data({
      access: session[:user_access], company: session[:company_id]
    })
    @company = Company.find(params[:id])
    
    if Flutter::CurrentUser.is_superadmin || (Flutter::CurrentUser.is_admin &&
      Flutter::CurrentUser.company == @company.id)
      if Flutter::CurrentUser.is_superadmin
        company_update = @company.update(params[:company].permit(
          :name, :kt, :email, :tel, :mobile, :fax, :contact_name, :comments,
          :address1, :address2, :postcode, :city, :shipping_address1,
          :shipping_address2, :shipping_postcode, :shipping_city, :enabled,
          :comments))
      elsif Flutter::CurrentUser.is_admin && Flutter::CurrentUser.company
        company_update = @company.update(params[:company].permit(
          :email, :tel, :mobile, :fax, :contact_name, :comments, :address1,
          :address2, :postcode, :city, :shipping_address1, :shipping_address2,
          :shipping_postcode, :shipping_city))
      end
      
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
    Flutter::CurrentUser.init_data({
      access: session[:user_access],
      company: session[:company_id]
    })
    @company = Company.find(params[:id])
    if Flutter::CurrentUser.is_superadmin
      if Flutter::CurrentUser.company == @company.id
        access_denied
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
      :name, :kt, :email, :tel, :mobile, :fax, :contact_name, :comments,
      :address1, :address2, :postcode, :city, :shipping_address1,
      :shipping_address2, :shipping_postcode, :shipping_city, :comments,
      :enabled)
  end
end
