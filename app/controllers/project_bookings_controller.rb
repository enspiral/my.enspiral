class ProjectBookingsController < IntranetController
  before_filter :parse_date_range

  def index
    @people = Person.active
    if params[:skill_ids].present?
      @people = @people.joins(:people_skills).where(people_skills: {skill_id: params[:skill_ids]})
    end

    if params[:country_ids].present?
      @people = @people.where(country_id: params[:country_ids])
    end

    if params[:city_ids].present?
      @people = @people.where(city_id: params[:city_ids])
    end

  end

  def parse_date_range
    @start_on = params[:start_on] || Date.today.at_beginning_of_week
    @finish_on = params[:finish_on] || @start_on + 8.weeks
  end
end
