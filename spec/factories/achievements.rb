FactoryBot.define do
  factory :achievement do
    key { "MyString" }
    name { "MyString" }
    description { "MyText" }
    icon { "MyString" }
    xp_reward { 1 }
    category { "MyString" }
    tier { "MyString" }
    requirements { "" }
  end
end
