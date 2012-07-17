class MarketingController < ApplicationController
  def index
    @featured_items = FeaturedItem.not_social.order('created_at DESC')
    @twitters = FeaturedItem.twitters
    @blogs = FeaturedItem.where(resource_type: 'Blog')
    @social_items = @twitters + @blogs
  end

  def about
    render 'marketing/static_pages/about'
  end

  def contact_us
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
end
