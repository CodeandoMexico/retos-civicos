Then(/^I should see translation for ([^\"]*)$/) do |key|
  response.should contain(I18n.t(key))
end

Then(/^I should see image with src (.+)$/) do |img_src|
  page.should have_xpath("//img[@src=#{img_src}]")
end

Then(/^I should see "(.+)"$/) do |text|
  page.should have_content(text)
end