Then(/^I should see translation for "([^\"]*)"$/) do |key|
  page.should have_content(I18n.t(key))
end

Then(/^I should not see translation for "([^\"]*)"$/) do |key|
  expect(page).not_to have_content(I18n.t(key))
end

Then(/^the button with translation "(.*)" should be (.*)/) do |name, status|
  is_disabled = status == "disabled"
  expect(page).to have_button(I18n.t(name), disabled: is_disabled)
end

Then(/^I should see translation for "([^\"]*)" within "([^\"]*)"$/) do |key, elem|
  within(elem) do
    page.should have_content(I18n.t(key))
  end
end

When(/^I click on the translation for "([^\"]*)"$/) do |key|
  click_on(I18n.t(key))
end

When(/^I click the "([^\"]*)" element$/) do |elem|
  find(elem.to_s).click
end

Then(/^I should see image with src (.+)$/) do |img_src|
  page.should have_xpath("//img[@src=#{img_src}]")
end

Then(/^\.(.*) should have background (.+)$/) do |div_class, img_src|
  page.first("div.#{div_class}")['style'].should include(img_src)
end

Then(/^I should see "(.+)"$/) do |text|
  page.should have_content(text)
end

Then(/^I should see the text "([^\"]*)" within "([^\"]*)"$/) do |text, elem|
  within(elem) do
    page.should have_content(text)
  end
end

Then(/^the button with translation "(.*)" should exist/) do |key|
  button_text = I18n.t(key)
  should have_button button_text
end

Then(/^I should see the translation for "([^\"]*)" within "([^\"]*)"$/) do |key, elem|
  text = I18n.t(key)
  within(elem) do
    page.should have_content(text)
  end
end

Then(/^I click on the translation for "([^\"]*)" within "([^\"]*)"$/) do |key, elem|
  text = I18n.t(key)
  step "I should see the text \"#{text}\" within \"#{elem}\""
end

Then(/^field "([^\"]*)" should be filled in with "([^\"]*)"$/) do |elem, text|
  finder = "input[value='#{text}']"
  within(elem) do
    expect(page).to have_selector(finder)
  end
end

Then(/^field "([^\"]*)" should contain the values "([^\"]*)"$/) do |elem, vals|
  vals_array = vals.split(/\s*,\s*/)
  vals_array.each do |val|
    finder = "input[value*='#{val}']"
    within(elem) do
      expect(page).to have_selector(finder)
    end
  end
end

Then(/^I should not see the text "([^\"]*)" within "([^\"]*)"$/) do |text, elem|
  within(elem) do
    page.should_not have_content(text)
  end
end

Then(/^I should see a link that goes to "([^\"]*)" within "([^\"]*)"$/) do |link, elem|
  within(elem) do
    page.should have_xpath("//a[@href=\"#{link}\"]")
  end
end

Then(/^I should not see "(.+)"$/) do |text|
  page.should_not have_content(text)
end

Given(/^I hover over (.+)$/) do |elem|
  page.execute_script("$('#{elem}').trigger('mouseenter')")
end

Then(/^the (.+) element should be visible$/) do |elem|
  find(:css, "#{elem}").should be_visible
end

Then(/^the (.+) element should be invisible$/) do |elem|
  find(:css, "#{elem}").should_not be_visible
end

Given(/^I unhover over (.+)$/) do |elem|
  page.execute_script("$('#{elem}').trigger('mouseleave')")
end

When(/^I click the translation for ([^\"]*)$/) do |key|
  page.should have_content(I18n.t(key))
  click_on(I18n.t(key))
end

Given(/^I wait for (\d+) seconds?$/) do |n|
  sleep(n.to_i)
end

When /^I fill in "([^\"]*)" with "([^\"]*)"$/ do |field, value|
  fill_in(field, with: value)
end

When /^I click on "([^\"]*)"$/ do |elem|
  click_on(elem)
end

When /^I visit the home page$/ do
  visit '/'
end

When /^I break$/ do
  binding.pry
end

When /^I wait for AJAX$/ do
  def wait_for_ajax
    Timeout.timeout(Capybara.default_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

  def finished_all_ajax_requests?
    page.evaluate_script('jQuery.active').zero?
  end

  wait_for_ajax
end
