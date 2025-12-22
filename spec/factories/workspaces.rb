FactoryBot.define do
  factory :workspace do
    name { Faker::Company.name }
    settings { {} }
  end
end
