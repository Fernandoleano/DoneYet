FactoryBot.define do
  factory :integration do
    association :workspace
    provider { :slack }
    access_token { "xoxb-test" }
    refresh_token { "xoxr-test" }
    bot_user_id { "U123456" }
    configuration { {} }
  end
end
