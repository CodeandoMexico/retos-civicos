Given(/^The user with e-mail: (.+) is following the (.+), (.+) brigade$/) do |em, city, state|
  @current_user = User.where(email: em).first
  brigade = Brigade.includes(:location).where(locations: { state: state, city: city }).first
  brigade_user_relation = BrigadeUser.where(user_id: @current_user.id, brigade_id: brigade.id).first
  expect(brigade_user_relation).to be_truthy
end

Given(/^The user with e-mail: (.+) is not following the (.+), (.+) brigade$/) do |em, city, state|
  @current_user = User.where(email: em).first
  brigade = Brigade.includes(:location).where(locations: { state: state, city: city }).first
  brigade_user_relation = BrigadeUser.where(user_id: @current_user.id, brigade_id: brigade.id).first
  expect(brigade_user_relation).to be_falsy
end
