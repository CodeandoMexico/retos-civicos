# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :location do
    zip_code "45050"
    state "Jalisco"
    city "Zapopan"
    locality "Ciudad del Sol"
  end
end
