# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

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
    alt_text = "#{person.name} - #{person.job_title}"
    
    if options[:with_link]
      link_to image_tag(gravatar, :class => class_names.join(" "), :alt => alt_text), person
    else
      image_tag(gravatar, :class => class_names.join(" "), :alt => alt_text)
    end
  end

end
