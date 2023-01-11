FactoryBot.define do
  factory :dataset do
    sequence(:guid) { |i| "#{i}" }
    sequence(:title) { |i| "dataset_#{i}" }
  end
end
