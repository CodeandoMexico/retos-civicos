Given(/^the following brigades exist:$/) do |table|
  Location.create!(zip_code: '64320', state: 'Nuevo León', city: 'Monterrey', locality: 'Col. Mitras Norte')
  table.hashes.each do |brigade|
    Brigade.create(brigade)
  end
end

Given(/^the following brigades with locations exist:$/) do |table|
  user = User.create!(email: 'brigade_test@test.com', password: '111111')
  table.hashes.each do |brigade|
    location = Location.create!(zip_code: brigade[:zip_code], state: brigade[:state], city: brigade[:city], locality: brigade[:locality])
    Brigade.create!(location_id: location.id, user_id: user.id)
  end
end

Given(/^I visit the brigade page for (.+), (.+)$/) do |city, state|
  brigade = Brigade.includes(:location).where(locations: { state: state, city: city }).first
  visit brigade_path(brigade)
end

Given(/^the following projects exist in brigade (.+), (.+):$/) do |city, state, table|
  brigade = Brigade.includes(:location).where(locations: { state: state, city: city }).first
  unless brigade.blank?
    table.hashes.each do |project|
      bp = BrigadeProject.create(title: project[:title], description: project[:description])
      user_ids = project[:users].split(/\s*,\s*/)
      user_ids.each do |user_id|
        bp.users << User.find(user_id)
      end
      tag_names = project[:tags].split(/\s*,\s*/)
      tag_names.each do |tag_name|
        bp.tags << Tag.create(name: tag_name)
      end
    end
  end
end

Given(/^no projects exist in brigade (.+), (.+):$/) do |city, state|
  brigade = Brigade.includes(:location).where(locations: { state: state, city: city }).first
  brigade.brigade_projects.destroy_all
end

When(/^I visit the brigade creation page$/) do
  visit new_brigade_path
end

When /^I click on location option with city "([^\"]*)"$/ do |_text|
  find(:xpath, "//div[contains(@data-city,'Monterrey')]").click
end

Then /^"([^\"]*)" should be the organizer$/ do |organizer|
  find(:xpath, "(//span[@class='member-name'])[1]").should contain organizer
end

Given(/^I type (.+) into the fuzzy search text box$/) do |text|
  fill_in 'location-query', with: text
end

Given(/^I can select the city (.+)$/) do |_city|
  find('.location-list').click
end

Given(/^the box around the location text box border should turn (.+)$/) do |color|
  page.find('#location-query')['style'].should include(color)
end

Given(/^there are no brigades$/) do
  Brigade.delete_all
end

Then /^I should be on the brigades listing page$/ do
  page.current_path.should eq brigades_path
end

Given(/^I am logged in as the brigade organizer of (.+), (.+) brigade$/) do |city, state|
  brigade = Brigade.includes(:location).where(locations: { state: state, city: city }).first
  @current_user = User.find(id: brigade.user.id)
  login_as(@current_user, scope: :user)
end

Given(/^I visit the (.+), (.+) brigade page as its organizer$/) do |city, state|
  brigade = Brigade.includes(:location).where(locations: { state: state, city: city }).first
  @current_user = User.find(id: brigade.user.id)
  login_as(@current_user, scope: :user)
  visit brigade_path(brigade)
end

Given(/^I am logged in as a follower of (.+), (.+) brigade$/) do |city, state|
  brigade = Brigade.includes(:location).where(locations: { state: state, city: city }).first
  brigade_user_relation = BrigadeUser.where(brigade_id: brigade.id).first
  @current_user = User.find(id: brigade_user_relation.user.id)
  login_as(@current_user, scope: :user)
end


def wait_for_ajax
  counter = 0
  while page.execute_script('return $.active').to_i > 0
    counter += 1
    sleep(0.1)
    raise 'AJAX request took longer than 5 seconds.' if counter >= 50
  end
end
