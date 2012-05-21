class PagesController < ApplicationController
  MATRIX = 12

  def index
    @feeds = FeedEntry.latest
    @people = Person.public.limit(12)

    if @people.length < MATRIX
      spaces_left = MATRIX - @people.length 
      more_people = Person.public - @people
      more_people = more_people.sort_by{ rand }.slice(0, spaces_left)
      @people += more_people
    end
  end

  def contact
    if params[:email].blank?
      flash[:error] = "you must provide an email address"
      redirect_to root_url
    else
      analytical.event("Submitted contact form")
      Notifier.contact(params).deliver
      flash[:notice] = 'Enquiry was sent successfully.'
      redirect_to root_url
    end
  end
end
