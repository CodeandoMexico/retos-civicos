FactoryGirl.define do
  factory :organization do
    subdomain nil
    association :user
  end
end
