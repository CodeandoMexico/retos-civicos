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

Given /^I am logged in as the user with email: (.+)/ do |em|
  @current_user = User.where(:email => em).first
  login_as(@current_user, :scope => :user)
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
end

Then(/^I should see the given profile page$/) do
  expect(current_path).to eq "/miembros/#{@current_user.id}-adrian-rangel"
end
