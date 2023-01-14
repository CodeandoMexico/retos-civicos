FactoryBot.define do
  factory :judge do
    company_name { 'name' }
    association :user, name: 'Judge'
  end
end
