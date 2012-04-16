class IntranetController < ApplicationController
  before_filter :require_staff
  before_filter :load_objects

  private
  def load_objects
    if params[:company_id]
      @company = current_person.admin_companies.where(id: params[:company_id]).first
    end
  end

end
