FactoryBot.define do
  factory :workspace_note do
    workspace { nil }
    content { "MyText" }
    note_type { "MyString" }
  end
end
