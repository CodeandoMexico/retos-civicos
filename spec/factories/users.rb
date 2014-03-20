FactoryGirl.define do
  factory :user do
    sequence(:name) {|n| "name#{n}" }
    sequence(:email) {|n| "correo#{n}@codeandomexico.org" }
    nickname "cmx"
    password "password"
    password_confirmation "password"
  end
end
