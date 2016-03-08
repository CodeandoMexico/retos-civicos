# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :report_card do
    association :evaluation
    association :entry
    grades [4, 4, 4]
  end
end
