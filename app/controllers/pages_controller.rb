class PagesController < ApplicationController
  MATRIX = 12

  def holding
  end

  def about
  end

  def recruitment
  end

  def index
    @feeds = FeedEntry.latest
    @people = Person.featured

    if @people.length < MATRIX
      spaces_left = MATRIX - @people.length 
      more_people = Person.with_gravatar - @people
      more_people = more_people.sort_by{ rand }.slice(0, spaces_left)
      @people += more_people
    end
  end

  def services
  end
  
  def contact
    @phone_number = '04 123 1234'
    
    Notifier.contact(params).deliver
    flash[:notice] = 'Enquiry was sent successfully.'
    redirect_to root_url
  end

  def social_media
  end
end
