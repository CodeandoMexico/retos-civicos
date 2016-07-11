Then(/^the tags "(.*)" should exist$/) do |tags|
  tag_array = tags.split(',')
  tag_array.each do |tag|
    tag_record = Tag.find(name: tag)
    expect(tag_record.name).to equal(tag)
  end
end

Then(/^there should only be (.*) tags$/) do |num_tags|
  expect(Tag.count).to equal(num_tags.to_i)
end

Then(/^the project "(.*)" should exist in brigade "(.*), (.*)"$/) do |project_title, city, state|
  brigade = Brigade.includes(:location).where(locations: { state: state, city: city }).first
  project = BrigadeProject.where(brigade_id: brigade.id, title: project_title)
  expect(project.count).to eq(1)
end

Then(/^the project "(.*)" should not exist in brigade "(.*), (.*)"$/) do |project_title, city, state|
  brigade = Brigade.includes(:location).where(locations: { state: state, city: city }).first
  project = BrigadeProject.where(brigade_id: brigade.id, title: project_title)
  expect(project.count).to eq(0)
end

Then(/^the project "(.*)" in brigade "(.*), (.*)" should have the tags "(.*)"$/) do |project_title, city, state, tags|
  brigade = Brigade.includes(:location).where(locations: { state: state, city: city }).first
  project = BrigadeProject.where(brigade_id: brigade.id, title: project_title).first
  project_tags = Tags.where(project_id: project.id)
  tag_array = tags.split(',')
  tag_array.each do |tag|
    tag_record = project_tags.find(name: tag)
    expect(tag_record.name).to equal(tag)
  end
end

Then(/^the project "(.*)" in brigade "(.*), (.*)" should have the description "(.*)"$/) do |project_title, city, state, description|
  brigade = Brigade.includes(:location).where(locations: { state: state, city: city }).first
  project = BrigadeProject.where(brigade_id: brigade.id, title: project_title).first
  expect(project.description).to eq(description)
end

Given(/^the following users are in brigade (.+), (.+):$/) do |city, state, table|
  brigade = Brigade.includes(:location).where(locations: { state: state, city: city }).first
  unless brigade.blank?
    table.hashes.each do |user|
      this_user = User.where(email: user[:email]).first || User.create!(user)
      BrigadeUser.create(user_id: this_user.id, brigade_id: brigade.id)
    end
  end
end