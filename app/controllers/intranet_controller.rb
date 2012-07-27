class IntranetController < ApplicationController
  before_filter :require_staff
  before_filter :load_objects
  before_filter :parse_date_range

  def check_blog_fetches
    @feed_url = params[:feed_url]   
    feed = Feedzirra::Feed.fetch_and_parse @feed_url
    return unless feed.respond_to?(:entries)
    entry = feed.entries.first
    render :json => entry.to_json
  end

  protected
  
  def load_objects
    if params[:company_id]
      @company = current_person.admin_companies.where(id: params[:company_id]).first
    end

    if params[:customer_id]
      @customer = Customer.where(id: params[:customer_id], company_id: current_person.admin_company_ids).first
    end

    if params[:project_id]
      if @project = Project.where(id: params[:project_id], company_id: current_person.admin_company_ids).first
      elsif @pm = current_person.project_leaderships.where(project_id: params[:project_id]).first
        @project = @pm.project
      end
    end

  end

  def parse_date_range
    @num_weeks = 8
    @start_on = (params[:start_on] || Date.today.at_beginning_of_week).to_date
    @finish_on = (params[:finish_on] || @start_on + (@num_weeks - 1).weeks).to_date
  end

  def admin_load_objects
    if params[:company_id]
      @company = Company.where(id: params[:company_id]).first
    end
  end

end
