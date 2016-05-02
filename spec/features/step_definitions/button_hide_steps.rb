Then(/^I should see a button for ([^\"]*)$/) do |site|
    link_id = "#" + site.downcase + "_snbutton"
    expect(page.has_css?(link_id)).to be true
end

Then(/^I should not see a button for ([^\"]*)$/) do |site|
    link_id = "#" + site.downcase + "_snbutton"
    expect(page.has_css?(link_id)).to be false
end

Then(/^I should see no social network buttons/) do
    expect(page.has_css?("[id$=_snbutton]", :count => 0)).to be true
end