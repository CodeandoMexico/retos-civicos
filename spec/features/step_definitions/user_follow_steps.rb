Given(/^I am following the (.+), (.+) brigade$/) do |city, state|
  @current_user ||= "No user signed in"
  brigade = Brigade.includes(:location).where(locations: { state: state, city: city }).first
  brigade_user_relation = BrigadeUser.where(user_id: @current_user.id, brigade_id: brigade.id).first
  expect(brigade_user_relation).to be_truthy
end