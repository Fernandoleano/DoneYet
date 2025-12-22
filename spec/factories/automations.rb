FactoryBot.define do
  factory :automation do
    workspace { nil }
    name { "MyString" }
    automation_type { 1 }
    config { "" }
    enabled { false }
    last_run_at { "2025-12-22 14:24:00" }
    next_run_at { "2025-12-22 14:24:00" }
  end
end
