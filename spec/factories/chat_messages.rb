FactoryBot.define do
  factory :chat_message do
    channel { nil }
    user { nil }
    content { "MyText" }
    parent_message { nil }
  end
end
