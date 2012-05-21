# Methods added to this helper will be available to all templates in the application.
module MarketingHelper
  def calculate_item_col_width(social_items)
    social_items.each do |si|
      si.instance_eval do
        def col_spaces
          instance_variable_get("@col_spaces")
        end        
        def col_spaces=(val) 
          instance_variable_set("@col_spaces",val)
        end
      end
      if si.twitter_only
        si.col_spaces = 2
      elsif si.resource_type == 'Blog'
        si.col_spaces = 4
      end
    end
  end

  def social_items_carousel(social_items)
    social_items_with_col_width = calculate_item_col_width(social_items)
    carousel_panes = social_items_with_col_width.shuffle.inject([]) {|r, e|arr = r.sort.reverse.detect {|arr|arr.sum{|a| a.col_spaces}+e.col_spaces < 11}; arr ? arr << e : r << [e]; r }
    html = ""
    carousel_panes.each_with_index do |set, index|
      html += render "marketing/social_items", index: index, set: set
    end
    html.html_safe
  end
end
