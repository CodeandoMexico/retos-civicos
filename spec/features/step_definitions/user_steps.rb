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