class CompaniesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company, only: [:edit, :update, :destroy]
  layout 'inspinia/admin_panel'

  def index
    @companies = Company.ordered
    @companies = @companies.moderated_by_user(current_user) unless admin?
    @companies = @companies.decorate
  end

  def new
    @company = Company.new
  end

  def create
    @company = Company.new(company_params)
    @company.user = current_user
    respond_to do |format|
      if @company.save
        format.html { redirect_to companies_path, notice: t('companies.notice.success_create') }
      else
        format.html { render :new }
      end
    end
  end

  def edit

  end

  def update
    respond_to do |format|
      if @company.can_update?(current_user)
        if @company.update(company_params)
          format.html { redirect_to companies_path, notice: t('companies.notice.success_update') }
        else
          format.html { render :edit }
        end
      else
        format.html { redirect_to companies_path, error: t('companies.notice.not_access') }
      end
    end
  end

  def destroy
    @company.destroy if @company.can_update?(current_user)
  end

  protected
  def set_company
    @company = (admin? ? Company : Company.by_user(current_user)).find params[:id]
  end

  def company_params
    param_keys = [:name, :logo, :description, :video_url, :marketing]
    param_keys.push(:moderated) if admin?
    params.require(:company).permit(*param_keys)
  end
end