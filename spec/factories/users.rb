FactoryGirl.define do
  factory :user do
    name "nombre"
    email "correo@codeandomexico.org"
    nickname "cmx"
    password "password"
    password_confirmation "password"
  end
end
