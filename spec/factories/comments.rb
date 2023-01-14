FactoryBot.define do
  factory :comment do
    body { 'Comment of parent post' }
    association :user
    association :commentable, factory: :challenge
  end
end
