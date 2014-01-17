FactoryGirl.define do
  factory :collaboration do
    association :user
    association :challenge
  end
end
