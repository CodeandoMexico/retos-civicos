FactoryGirl.define do
  factory :challenge do
    sequence(:title) { |i| "El titulo #{i}" }
    description "descripcion"
    about "este es mi test"
    pitch "piitch del challenge"
    
    association :organization

  end
end
