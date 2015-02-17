# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :report_card do
    evaluation_id 1
    entry_id 1
    grades "MyText"
  end
end
