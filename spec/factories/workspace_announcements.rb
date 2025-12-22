FactoryBot.define do
  factory :workspace_announcement do
    workspace { nil }
    user { nil }
    title { "MyString" }
    content { "MyText" }
    priority { 1 }
    pinned { false }
  end
end
