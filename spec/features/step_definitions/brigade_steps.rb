Given(/^the following brigades exist:$/) do |table|
  Location.create!(zip_code: '64320', state: 'Nuevo León', city: "Monterrey", locality: "Col. Mitras Norte")
  table.hashes.each do |brigade|
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
    user = User.create!(user)
    BrigadeUser.create!(user_id: user.id, brigade_id: brigade_id)
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