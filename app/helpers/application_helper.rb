# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def google_account_id
    "UA-1616271-1" if Rails.env.production?
  end
end
