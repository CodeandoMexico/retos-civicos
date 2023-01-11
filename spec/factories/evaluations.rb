# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :evaluation do
    association :challenge
    association :judge
  end
end
