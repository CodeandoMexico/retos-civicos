FactoryBot.define do
  factory :collaboration do
    association :member
    association :challenge
  end
end
