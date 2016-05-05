Given(/^the following users exist:$/) do |table|
  table.hashes.each do |user|
    User.create!(user)
  end
end

Given /^I am logged in as a user with email "(.*)" and name "(.*)"$/ do |email, name|
  @current_user = User.create!(email: email, name: name, password: "111111")
  login_as(@current_user, :scope => :user)
end

Given /^I am logged in as a user$/ do
  @current_user = User.create!(email: 'test0@test.com', password: "111111")
  login_as(@current_user, :scope => :user)
end

Given /^I am not logged in$/ do
  @current_user = User.create!(email: 'throwaway@test.com', password: "111111")
  login_as(@current_user, :scope => :user)
  logout
end

Given /^I am logged in as the user with email: (.+)/ do |em|
  @current_user = User.where(:email => em).first
  login_as(@current_user, :scope => :user)
  expect(@current_user).to be_truthy
end

Given /^I log out$/ do
  logout
end

Given /^I have just updated my information$/ do
  @current_user = User.create!(email: 'test@test.com', password: '111111')
  login_as(@current_user, scope: :user)
  visit edit_member_path(@current_user)
  fill_in 'member_name', with: 'Adrian Rangel'
  click_on 'Actualizar'
  visit member_path(@current_user)
end

Given /^I have a link to another user profile$/ do
  @current_user = User.create!(email: 'test@test.com', password: '111111')
  @other_user = User.create!(email: 'test2@test.com', password: '111111')
  login_as(@current_user, scope: :user)
  visit member_path(@other_user)
end

Given /^Give I don't want to show my public profile$/ do
  @current_user = User.create!(email: 'test@test.com', password: '111111')
  login_as(@current_user, scope: :user)
  visit edit_member_path(@current_user)
  fill_in 'member_name', with: 'Adrian Rangel'
  find(:css, '#member_show_profile').set(false)
  click_on 'Actualizar'
  logout
  @other_user = User.create!(email: 'test2@test.com', password: '111111')
  login_as(@other_user, scope: :user)
  visit member_path(@current_user)
end

Then(/^I should see the given profile page$/) do
  expect(current_path).to eq "/miembros/#{@current_user.to_param}"
end

Then(/^I should see the other users profile page$/) do
  expect(current_path).to eq "/miembros/#{@other_user.to_param}"
end

Then(/^my profile should be hidden to other users$/) do
  raise_error(Rack::Test::Error)
end

Given /^I should be on the login page$/ do
  expect(page).to have_content("Necesitas iniciar sesión o registrarte para continuar")
end
