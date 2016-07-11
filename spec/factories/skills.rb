FactoryGirl.define do
  factory :skill do
    sequence(:name) { |i| "skill_#{i}" }

    factory :skill_with_user do
      ignore do
        users_count 1
      end

      after(:create) do |skill, evaluator|
        FactoryGirl.create_list(:user_skill, evaluator.skill_count, skill: skill)
      end
    end
  end
end
