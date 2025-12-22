# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_12_22_210955) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "achievements", force: :cascade do |t|
    t.string "category"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "icon"
    t.string "key", null: false
    t.string "name", null: false
    t.json "requirements"
    t.string "tier"
    t.datetime "updated_at", null: false
    t.integer "xp_reward", default: 0
    t.index ["key"], name: "index_achievements_on_key", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "announcement_reads", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "read_at"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "workspace_announcement_id", null: false
    t.index ["user_id"], name: "index_announcement_reads_on_user_id"
    t.index ["workspace_announcement_id"], name: "index_announcement_reads_on_workspace_announcement_id"
  end

  create_table "automations", force: :cascade do |t|
    t.integer "automation_type"
    t.json "config"
    t.datetime "created_at", null: false
    t.boolean "enabled", default: true
    t.datetime "last_run_at"
    t.string "name"
    t.datetime "next_run_at"
    t.datetime "updated_at", null: false
    t.bigint "workspace_id", null: false
    t.index ["workspace_id"], name: "index_automations_on_workspace_id"
  end

  create_table "integrations", force: :cascade do |t|
    t.text "access_token"
    t.string "bot_user_id"
    t.jsonb "configuration"
    t.datetime "created_at", null: false
    t.integer "provider"
    t.text "refresh_token"
    t.datetime "updated_at", null: false
    t.bigint "workspace_id", null: false
    t.index ["workspace_id"], name: "index_integrations_on_workspace_id"
  end

  create_table "meetings", force: :cascade do |t|
    t.bigint "captain_id", null: false
    t.datetime "created_at", null: false
    t.datetime "dispatched_at"
    t.string "meet_code"
    t.datetime "started_at"
    t.integer "status"
    t.string "title"
    t.datetime "updated_at", null: false
    t.bigint "workspace_id", null: false
    t.index ["captain_id"], name: "index_meetings_on_captain_id"
    t.index ["meet_code"], name: "index_meetings_on_meet_code"
    t.index ["workspace_id"], name: "index_meetings_on_workspace_id"
  end

  create_table "mission_assignments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "mission_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["mission_id", "user_id"], name: "index_mission_assignments_on_mission_id_and_user_id", unique: true
    t.index ["mission_id"], name: "index_mission_assignments_on_mission_id"
    t.index ["user_id"], name: "index_mission_assignments_on_user_id"
  end

  create_table "mission_comments", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.bigint "mission_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["mission_id"], name: "index_mission_comments_on_mission_id"
    t.index ["user_id"], name: "index_mission_comments_on_user_id"
  end

  create_table "missions", force: :cascade do |t|
    t.bigint "agent_id", null: false
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "difficulty", default: 1
    t.jsonb "dispatch_metadata"
    t.integer "dispatch_status"
    t.datetime "due_at"
    t.datetime "last_reminded_at"
    t.bigint "meeting_id", null: false
    t.datetime "started_at"
    t.integer "status"
    t.integer "threat_level", default: 1
    t.string "title"
    t.datetime "updated_at", null: false
    t.integer "xp_reward", default: 100
    t.index ["agent_id"], name: "index_missions_on_agent_id"
    t.index ["meeting_id"], name: "index_missions_on_meeting_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "user_achievements", force: :cascade do |t|
    t.bigint "achievement_id", null: false
    t.datetime "created_at", null: false
    t.datetime "unlocked_at"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["achievement_id"], name: "index_user_achievements_on_achievement_id"
    t.index ["user_id", "achievement_id"], name: "index_user_achievements_on_user_id_and_achievement_id", unique: true
    t.index ["user_id"], name: "index_user_achievements_on_user_id"
  end

  create_table "user_stats", force: :cascade do |t|
    t.string "code_name"
    t.integer "comments_posted", default: 0
    t.datetime "created_at", null: false
    t.integer "current_streak", default: 0
    t.date "last_login_date"
    t.integer "level", default: 1
    t.integer "longest_streak", default: 0
    t.integer "missions_completed", default: 0
    t.integer "missions_created", default: 0
    t.string "rank", default: "Recruit"
    t.integer "total_xp", default: 0
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_user_stats_on_user_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "name"
    t.string "password_digest", null: false
    t.string "role"
    t.string "slack_user_id"
    t.datetime "updated_at", null: false
    t.bigint "workspace_id", null: false
    t.string "zoho_user_id"
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
    t.index ["workspace_id"], name: "index_users_on_workspace_id"
  end

  create_table "workspace_announcements", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.boolean "pinned"
    t.integer "priority"
    t.string "title"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "workspace_id", null: false
    t.index ["user_id"], name: "index_workspace_announcements_on_user_id"
    t.index ["workspace_id"], name: "index_workspace_announcements_on_workspace_id"
  end

  create_table "workspace_notes", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.string "note_type"
    t.datetime "updated_at", null: false
    t.bigint "workspace_id", null: false
    t.index ["workspace_id"], name: "index_workspace_notes_on_workspace_id"
  end

  create_table "workspaces", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.jsonb "settings"
    t.string "stripe_customer_id"
    t.string "stripe_subscription_id"
    t.integer "subscription_status"
    t.datetime "updated_at", null: false
    t.index ["stripe_customer_id"], name: "index_workspaces_on_stripe_customer_id"
    t.index ["stripe_subscription_id"], name: "index_workspaces_on_stripe_subscription_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "announcement_reads", "users"
  add_foreign_key "announcement_reads", "workspace_announcements"
  add_foreign_key "automations", "workspaces"
  add_foreign_key "integrations", "workspaces"
  add_foreign_key "meetings", "users", column: "captain_id"
  add_foreign_key "meetings", "workspaces"
  add_foreign_key "mission_assignments", "missions"
  add_foreign_key "mission_assignments", "users"
  add_foreign_key "mission_comments", "missions"
  add_foreign_key "mission_comments", "users"
  add_foreign_key "missions", "meetings"
  add_foreign_key "missions", "users", column: "agent_id"
  add_foreign_key "sessions", "users"
  add_foreign_key "user_achievements", "achievements"
  add_foreign_key "user_achievements", "users"
  add_foreign_key "user_stats", "users"
  add_foreign_key "users", "workspaces"
  add_foreign_key "workspace_announcements", "users"
  add_foreign_key "workspace_announcements", "workspaces"
  add_foreign_key "workspace_notes", "workspaces"
end
