class IntranetController < ApplicationController
  before_filter :require_staff
  before_filter :load_objects

  protected
  def current_ability
    @current_ability ||= Ability.new(current_person, @company)
  end
  
  def load_objects
    if params[:company_id]
      @company = current_person.admin_companies.where(id: params[:company_id]).first
    end
  end

  def admin_load_objects
    if params[:company_id]
      @company = Company.where(id: params[:company_id]).first
    end
  end
end
