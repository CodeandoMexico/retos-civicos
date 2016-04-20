Given(/^the following brigades exist:$/) do |table|
  Location.create!(zip_code: '64320', state: 'Nuevo León', city: "Monterrey", locality: "Col. Mitras Norte")
  table.hashes.each do |brigade|
    Brigade.create(brigade)
  end
end

Given(/^the following brigades with locations exist:$/) do |table|
  table.hashes.each do |brigade|
    location = Location.create!(zip_code: brigade.zip, state: brigade.state, city: brigade.city, locality: brigade.locality)
    brigade[:location_id] = location.id
    Brigade.create(brigade)
  end
end

Given(/^I visit the brigade page for (.+), (.+)$/) do |city, state|
  brigade = Brigade.includes(:location).where(locations: { state: state, city: city }).first
  visit brigade_path(brigade)
end

Given(/^the following users are in brigade (.+), (.+):$/) do |city, state, table|
  brigade_id = Brigade.includes(:location).where(locations: { state: state, city: city }).first.id
  table.hashes.each do |user|
    this_user = User.where(:email => user[:email]).first || User.create!(user)
    BrigadeUser.create(user_id: this_user.id, brigade_id: brigade_id)
  end
end

When(/^I visit the brigade creation page$/) do
  visit new_brigade_path
end

When /^I click on location option with city "([^\"]*)"$/ do |text|
  find(:xpath, "//div[contains(@data-city,'Monterrey')]").click
end

Then /^"([^\"]*)" should be the organizer$/ do |organizer|
  find(:xpath, "(//span[@class='member-name'])[1]").should contain organizer
end

Given(/^I type (.+) into the fuzzy search text box$/) do |text|
  fill_in 'location-query', with: text
end

Given(/^I can select the city (.+)$/) do |city|
  find('.location-list').click
end
  
Given(/^the box around the location text box border should turn (.+)$/) do |color|
  page.find("#location-query")['style'].should include(color)
end

def wait_for_ajax
  counter = 0
  while page.execute_script("return $.active").to_i > 0
    counter += 1
    sleep(0.1)
    raise "AJAX request took longer than 5 seconds." if counter >= 50
  end
end