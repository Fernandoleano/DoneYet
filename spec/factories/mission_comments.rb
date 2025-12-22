FactoryBot.define do
  factory :mission_comment do
    mission { nil }
    user { nil }
    content { "MyText" }
  end
end
