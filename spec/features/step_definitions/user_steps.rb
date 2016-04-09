Given(/^the following users exist:$/) do |table|
  table.hashes.each do |user|
    User.create(user)
  end
end

Given /^I am logged in as a user$/ do
  @current_user = User.create!(email: 'test@test.com', password: "111111")
  login_as(@current_user, :scope => :user)
end

Given /^I log out$/ do
  logout
end

Given /^I have just updated my information$/ do
  @current_user = User.create!(email: 'test@test.com', password: '111111')
  login_as(@current_user, scope: :user)
  fill_in 'member_name', with: 'Adrian Rangel'
  click_on 'Actualizar'
  expect(current_path).to eq member_path(@current_user)
end