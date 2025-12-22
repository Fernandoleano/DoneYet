FactoryBot.define do
  factory :mission do
    association :meeting
    association :agent, factory: :user
    title { Faker::Lorem.sentence }
    status { :pending }
    due_at { 24.hours.from_now }
  end
end
