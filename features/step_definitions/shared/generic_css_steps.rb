Then /^I should see multiple ([\w\s]*)$/ do |name|
  singular, plural = str_to_css_names(name)
  within ".content" do |scope|
    scope.should have_selector(".#{plural} .#{singular}:nth-child(2)")
  end
end

Then /^I should see (\d*) ([\s\w]*)$/ do |number, name|
  singular, plural = str_to_css_names(name)
  within ".content" do |scope|
    if number.to_i == 0
      scope.should_not have_selector(".#{plural} .#{singular}")
    else
      scope.should have_selector(".#{plural} .#{singular}:nth-child(#{number})")
    end
  end
end

When /^I view the first ([\s\w]*)/ do |name|
  singular, plural = str_to_css_names(name)
  within ".content .#{plural} .#{singular}" do |scope|
    scope.click_link "View"
  end
  item = assigns(singular.to_sym)
  item.should_not be_nil
  eval "@#{singular} = item"
end
