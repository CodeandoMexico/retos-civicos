FactoryGirl.define do
  factory :entry do
    sequence(:name) {|n| "Entry No. #{n}" }
    description 'This is my entry!'
    idea_url 'slideshare.com/loqusea'
    association :member
    association :challenge

    trait :public do
      self.public true
    end
  end
end
