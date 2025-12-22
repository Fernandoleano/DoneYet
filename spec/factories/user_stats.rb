FactoryBot.define do
  factory :user_stat do
    user { nil }
    total_xp { 1 }
    level { 1 }
    missions_completed { 1 }
    missions_created { 1 }
    comments_posted { 1 }
    current_streak { 1 }
    longest_streak { 1 }
    last_login_date { "2025-12-22" }
    rank { "MyString" }
    code_name { "MyString" }
  end
end
