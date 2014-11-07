# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :judge do
    company_name 'name'
    association :user, name: 'Judge'
  end
end
