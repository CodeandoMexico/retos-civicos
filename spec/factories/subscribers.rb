FactoryGirl.define do
  factory :subscriber do
    sequence(:email) {|n| "correo#{n}@codeandomexico.org" }
  end
end
