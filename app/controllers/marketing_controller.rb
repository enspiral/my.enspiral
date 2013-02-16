class MarketingController < ApplicationController
  def index
    @featured_items = FeaturedItem.not_social.order('created_at DESC')
  end

  def about
    @title = "About"
    render 'marketing/static_pages/about'
  end

  def vision
    @title = "Our Collective Vision"
    render 'marketing/static_pages/vision'
  end

  def contact_us
    @title = "Contact Us"
    render 'marketing/static_pages/contact_us'
  end

  def contact
    if request.xhr?
      if params[:email].blank?
        render :json => {message: "Please enter email."}, status: :unprocessable_entity
      else
        analytical.event("Submitted contact form")
        Notifier.contact(params).deliver
        render :json => {message: "Message sent, Thanks!"}, status: :created
      end
    else
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

  def load_social_items
    @twitters = FeaturedItem.twitters
    @blogs = FeaturedItem.where(resource_type: 'Blog')
    @social_items = @twitters + @blogs
    render partial: '/marketing/tweets_and_blogs', social_items: @social_items
  end

  def fetch_tweets
    account = params[:account]
    unless account.blank?
      tweets = Twitter.user_timeline(account).first(10)
      render :json => tweets.to_json
    end
  end

  protected
    def authenticate
      authenticate_or_request_with_http_basic do |username, password|
        username == "enspiral" && password == "absonderlich"
      end
    end

end
