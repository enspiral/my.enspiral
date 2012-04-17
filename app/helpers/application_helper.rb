# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def google_account_id
    "UA-1616271-1" if Rails.env.production?
  end

  def nice_date date
    date.strftime("%e %b %y")
  end

  def person_capacity_preview person
    @html =""
    @weeks = [Date.today.beginning_of_week, Date.today.beginning_of_week + 1.week, Date.today.beginning_of_week + 2.weeks, Date.today.beginning_of_week + 3.weeks]
    @bookings = ProjectBooking.get_persons_projects_bookings(person, @weeks)
    @formatted_dates = ProjectBooking.get_formatted_dates @weeks
    @totals = ProjectBooking.get_persons_total_booked_hours_by_week person, @weeks
    @html += '<table class="table table-striped table-condensed table-bordered"><thead><th></th>'
    @formatted_dates.each do |d|
      @html += "<th>#{d}</th>"
    end
    @html += '</thead><tbody>'
    @bookings.each do |k, b| 
      @array_of_totals = b.map{|b| b[1]}
      @total_for_project = @array_of_totals.inject{|sum, x| sum + x}.inspect
      if @total_for_project.to_i > 0
        @project_name = Project.find(k).name
        @html += "<tr><td>#{@project_name}</td>"
        b.each do |b|
          @html += "<td>#{b[1]}</td>"
        end
        @html += "</tr>"
      end
    end
    @html += "<tr class='special'><td>Totals:</td>"

    @totals.each do |t|
      @html += "<td>#{t[1]}</td>"
    end
    @html += "</tr>"
    @html += '</tbody><table>'
    return @html
  end

  def person_capacity_status_class person, weeks
    @weeks = [Date.today.beginning_of_week, Date.today.beginning_of_week + 1.week, Date.today.beginning_of_week + 2.weeks, Date.today.beginning_of_week + 3.weeks]
    @totals = ProjectBooking.get_persons_total_booked_hours_by_week person, @weeks
    @ideal_hrs = person.default_hours_available ? person.default_hours_available : 40
    @target = @ideal_hrs * @weeks.size
    @totals = @totals.map{|t| t[1]}
    @total = @totals.inject{|sum, t| sum + t}
    if @total >= @target - @weeks.size * 5
      @class = "filter-capacity-good"
    elsif (@total >= @target / 2) and (@total < @target - @weeks.size * 5)
      @class = "filter-capacity-okay"
    else
      @class = "filter-capacity-bad"
    end
    @class
  end

  def display_gravatar(person, size = 80, options ={})
    class_names = ["gravatar"]

    class_names << "rounded" if options[:rounded]
    
    if options[:border]
      if size > 100 && size < 255
        class_names << "medium"
      elsif size >= 255
        class_names << "large"
      else
        class_names << "small"
      end
    end

    gravatar = person.gravatar_url(:size => size)
    
    alt_text = person.name
    alt_text += " - #{person.job_title}" unless person.job_title.blank?

    if options[:with_link]
      link_to image_tag(gravatar, :class => class_names.join(" "), :alt => alt_text, :title => alt_text), person
    else
      image_tag(gravatar, :class => class_names.join(" "), :alt => alt_text, :title => alt_text)
    end
  end

end
