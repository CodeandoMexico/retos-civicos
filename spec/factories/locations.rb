# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :location do
    zip_code "MyString"
    state "MyString"
    city ""
    locality ""
  end
end
