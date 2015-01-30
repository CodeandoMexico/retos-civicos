FactoryGirl.define do
  factory :organization do
    sequence(:slug) { |i| "challenge_slug_#{i}"}
    association :user, name: 'Super Org'
  end
end
