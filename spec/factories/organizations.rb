FactoryGirl.define do
  factory :organization do
    slug 'superorg'
    association :user, name: 'Super Org'
  end
end
