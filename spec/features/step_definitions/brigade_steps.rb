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
    user_id = User.create!(user)
    BrigadeUser.create(user_id: user_id, brigade_id: brigade_id)
  end
end

Given(/^I visit the create brigade page$/)
  visit '/brigade/nuevo'
end

Given(/^I type (.+) into the fuzzy search text box$/) do |text|
  fill_in 'location-query', with: text
end

Given(/^I select the city Monterrey$/) do
  click_on 'location-list'
  
Given(/^the box around the location text box border should turn (.+)$/) do |color|
  (find(:css, "#{location-query}").native.style('border') == color).should be_falsey
end


  
  
  