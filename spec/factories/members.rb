FactoryBot.define do
  factory :member do
    association :user, name: 'Juanito'
  end
end
