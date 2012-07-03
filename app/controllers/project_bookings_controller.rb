class ProjectBookingsController < IntranetController
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
end
