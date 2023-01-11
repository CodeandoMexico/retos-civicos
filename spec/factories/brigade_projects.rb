# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :brigade_project do
    title "Timbuktu"
    description "Project that makes people feel closer"
    brigade_id 1

    ignore do
      given_tags ['html', 'scheme', 'java']
    end

    factory :brigade_project_with_tags do

      after(:create) do |brigade_project, evaluator|
        evaluator.given_tags.each do |tag|
          brigade_project.tags << FactoryBot.create(:tag, name: tag)
        end
      end
    end
  end
end
