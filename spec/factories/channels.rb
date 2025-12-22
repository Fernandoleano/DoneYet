FactoryBot.define do
  factory :channel do
    workspace { nil }
    name { "MyString" }
    description { "MyText" }
    private { false }
    created_by { nil }
  end
end
