FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "name#{n}" }
    sequence(:email) { |n| "correo#{n}@codeandomexico.org"; }
    nickname { 'cmx' }
    password { 'password' }
    password_confirmation { 'password' }

    factory :user_with_skills do
      ignore do
        skills_count 1
      end

      after(:create) do |user, evaluator|
        FactoryBot.create_list(:user_skill, evaluator.skills_count, user: user)
      end
    end
  end
end
