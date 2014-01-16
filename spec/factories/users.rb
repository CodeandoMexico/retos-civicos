FactoryGirl.define do
  factory :user do
    name "nombre"
    sequence(:email) {|n| "correo#{n}@codeandomexico.org" }
    nickname "cmx"
    password "password"
    password_confirmation "password"
  end
end
