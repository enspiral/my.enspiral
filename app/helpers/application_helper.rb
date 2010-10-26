# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  require 'net/http'
  require 'digest/md5'
  # Is there a Gravatar for this email? Optionally specify :rating and :timeout.
  def gravatar?(email, options = {})
    hash = Digest::MD5.hexdigest(email.to_s.downcase)
    options = { :rating => 'x', :timeout => 2 }.merge(options)
    http = Net::HTTP.new('www.gravatar.com', 80)
    http.read_timeout = options[:timeout]
    response = http.request_head("/avatar/#{hash}?rating=#{options[:rating]}&default=http://gravatar.com/avatar")
    response.code != '302'
  rescue StandardError, Timeout::Error
    true  # Don't show "no gravatar" if the service is down or slow
  end

  def display_gravatar(size = 80, person = null)
    if size > 100 && size < 255
      @border_size = "medium"
    elsif size >= 255
      @border_size = "large"
    else
      @border_size = "small"
    end

    image_tag(person.gravatar_url(:size => size), :class=>"gravatar #{person.user.role} #{@border_size}")
  end

end
