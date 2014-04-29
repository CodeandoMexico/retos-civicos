FactoryGirl.define do
  factory :organization do
    subdomain 'superorg'
    association :user, name: 'Super Org'
  end
end
