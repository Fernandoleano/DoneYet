FactoryBot.define do
  factory :meeting do
    association :workspace
    association :captain, factory: :user
    title { Faker::Company.catch_phrase }
    status { :briefing }
    started_at { Time.current }
  end
end
