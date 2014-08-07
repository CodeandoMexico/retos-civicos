FactoryGirl.define do
  factory :challenge do
    sequence(:title) { |i| "El titulo #{i}" }
    description "descripcion"
    about "este es mi test"
    pitch "piitch del challenge"
    association :organization

    starts_on { Date.current }
    ideas_phase_due_on { 1.month.from_now.to_date }
    ideas_selection_phase_due_on { 2.months.from_now.to_date }
    prototypes_phase_due_on { 3.months.from_now.to_date }
    finish_on { 4.months.from_now.to_date }
    finish_date { 4.months.from_now.to_date }

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
