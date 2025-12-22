FactoryBot.define do
  factory :user do
    email_address { Faker::Internet.email }
    password { "password" }
    name { Faker::Name.name }
    role { "agent" }
    association :workspace
  end
end
