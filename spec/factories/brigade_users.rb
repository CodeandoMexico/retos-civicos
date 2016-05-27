# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :brigade_user, class: 'BrigadeUsers' do
    user nil
    brigade nil
  end
end
