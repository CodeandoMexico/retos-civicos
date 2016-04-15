FactoryGirl.define do
  factory :subscriber do
    sequence(:email) { |n| "subscriber-correo#{n}@codeandomexico.org" }
  end
end
