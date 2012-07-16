class ProfilesController < IntranetController
  helper_method :total_hours_per_week
  helper_method :weeks_array
  def roladex
    @people = Person.order("first_name asc")
  end
  
  def edit
    @person = current_person
  end

  def show
    if params[:id]
      @person = Person.find(params[:id])
    else
      @person = current_person
    end

    @start_on = Date.today.at_beginning_of_week
    @end_on = @start_on + 8.weeks

    @project_bookings = @person.project_bookings.where(week: @start_on..@end_on)
    @hours_per_week = @project_bookings.total_hours_per_week(@start_on, @end_on)
    @week_dates = ProjectBooking.week_dates(@start_on, @end_on)
  end

  def update
    @person = current_person
    
    if params[:country].blank?
      country = Country.find_by_id(params[:person][:country_id])
    elsif params[:country]
      country = Country.find_or_create_by_name(params[:country])
    end

    if country
      if params[:city].blank?
        city = country.cities.find_by_id(params[:person][:city_id])
      else
        city = country.cities.find_or_create_by_name(params[:city])
      end

      params[:person].merge! :country_id => country.id
      params[:person].merge! :city_id => city.id if city
    end

    if @person.update_attributes(params[:person])
      flash[:success] = 'Profile Updated'
      redirect_to ({action: :show})
    else
      render :edit
    end
  end

  def check_blog_fetches
    @feed_url = params[:feed_url]   
    feed = Feedzirra::Feed.fetch_and_parse @feed_url
    return unless feed.respond_to?(:entries)
    entry = feed.entries.first
    render :json => entry.to_json
  end

  def fetch_tweets
    account = params[:account]
    unless account.blank?
      tweets = Twitter.user_timeline(account).first(10)
      render :json => tweets.to_json
    end
  end

end
