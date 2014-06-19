FactoryGirl.define do
  factory :challenge do
    sequence(:title) { |i| "El titulo #{i}" }
    description "descripcion"
    about "este es mi test"
    pitch "piitch del challenge"
    association :organization

    ideas_phase_due_on { 1.month.from_now }
    ideas_selection_phase_due_on { 2.month.from_now }

    trait :inactive do
      status 'finished'
    end

    trait :open do
      status 'open'
    end

    trait :finished do
      status 'finished'
    end

    trait :working_on do
      status 'working_on'
    end
  end
end
