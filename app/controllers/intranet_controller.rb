class IntranetController < ApplicationController
  before_filter :require_staff
  before_filter :load_objects
  helper_method :company_or_project, :invoice_path, :invoices_path

  protected
  
  def magic_invoices_path(action_or_options = nil)
    if action_or_options.respond_to?(:to_hash)
      options = action_or_options
    else
      options = {action: action_or_options}
    end
    if @project and @company
      polymorphic_path([@company, @project, Invoice], options)
    else
      polymorphic_path([company_or_project, Invoice], options)
    end
  end

  def magic_invoice_path(invoice, action_or_options = nil)
    if action_or_options.respond_to?(:to_hash)
      options = action_or_options
    else
      options = {action: action_or_options}
    end
    if @project and @company
      polymorphic_path([@company, @project, invoice], options)
    else
      polymorphic_path([company_or_project, invoice], options)
    end
  end

  def load_objects
    if params[:company_id]
      @company = current_person.admin_companies.where(id: params[:company_id]).first
    end

    if params[:project_id]
      if @company
        @project = @company.projects.where(id: params[:project_id]).first
      elsif @pm = current_person.project_leaderships.where(project_id: params[:project_id]).first
        @project = @pm.project
      end
    end
  end

  def company_or_project
    @project || @company
  end

  def admin_load_objects
    if params[:company_id]
      @company = Company.where(id: params[:company_id]).first
    end
  end
end
