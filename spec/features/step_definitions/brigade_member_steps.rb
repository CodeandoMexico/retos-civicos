Then /^I should see "([^\"]*)" in the members popup$/ do |cont|
  popup = page.find('#members-modal')
  expect(popup).to have_content(cont)
end

Then /^I should not see "([^\"]*)" in the members popup$/ do |cont|
  popup = page.find('#members-modal')
  expect(popup).not_to have_content(cont)
end
