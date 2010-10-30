# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

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
