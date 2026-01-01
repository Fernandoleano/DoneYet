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

ActiveRecord::Schema[8.1].define(version: 2026_01_01_120000) do
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

  create_table "ahoy_events", force: :cascade do |t|
    t.string "name"
    t.jsonb "properties"
    t.datetime "time"
    t.bigint "user_id"
    t.bigint "visit_id"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time"
    t.index ["properties"], name: "index_ahoy_events_on_properties", opclass: :jsonb_path_ops, using: :gin
    t.index ["user_id"], name: "index_ahoy_events_on_user_id"
    t.index ["visit_id"], name: "index_ahoy_events_on_visit_id"
  end

  create_table "ahoy_visits", force: :cascade do |t|
    t.string "app_version"
    t.string "browser"
    t.string "city"
    t.string "country"
    t.string "device_type"
    t.string "ip"
    t.text "landing_page"
    t.float "latitude"
    t.float "longitude"
    t.string "os"
    t.string "os_version"
    t.string "platform"
    t.text "referrer"
    t.string "referring_domain"
    t.string "region"
    t.datetime "started_at"
    t.text "user_agent"
    t.bigint "user_id"
    t.string "utm_campaign"
    t.string "utm_content"
    t.string "utm_medium"
    t.string "utm_source"
    t.string "utm_term"
    t.string "visit_token"
    t.string "visitor_token"
    t.index ["user_id"], name: "index_ahoy_visits_on_user_id"
    t.index ["visit_token"], name: "index_ahoy_visits_on_visit_token", unique: true
    t.index ["visitor_token", "started_at"], name: "index_ahoy_visits_on_visitor_token_and_started_at"
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

  create_table "channel_memberships", force: :cascade do |t|
    t.bigint "channel_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["channel_id"], name: "index_channel_memberships_on_channel_id"
    t.index ["user_id"], name: "index_channel_memberships_on_user_id"
  end

  create_table "channels", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "created_by_id"
    t.text "description"
    t.boolean "is_direct_message", default: false, null: false
    t.string "name"
    t.boolean "private", default: false
    t.datetime "updated_at", null: false
    t.bigint "workspace_id", null: false
    t.index ["workspace_id", "name"], name: "index_channels_on_workspace_id_and_name", unique: true
    t.index ["workspace_id"], name: "index_channels_on_workspace_id"
  end

  create_table "chat_messages", force: :cascade do |t|
    t.bigint "channel_id", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.integer "parent_message_id"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["channel_id"], name: "index_chat_messages_on_channel_id"
    t.index ["parent_message_id"], name: "index_chat_messages_on_parent_message_id"
    t.index ["user_id"], name: "index_chat_messages_on_user_id"
  end

  create_table "feature_requests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "title"
    t.datetime "updated_at", null: false
    t.integer "votes_count", default: 0
  end

  create_table "feature_votes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "feature_request_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["feature_request_id", "user_id"], name: "index_feature_votes_on_feature_request_id_and_user_id", unique: true
    t.index ["feature_request_id"], name: "index_feature_votes_on_feature_request_id"
    t.index ["user_id"], name: "index_feature_votes_on_user_id"
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
    t.boolean "is_timer_running", default: false
    t.datetime "last_reminded_at"
    t.bigint "meeting_id", null: false
    t.datetime "started_at"
    t.integer "status"
    t.integer "threat_level", default: 1
    t.integer "time_tracked_seconds", default: 0
    t.datetime "timer_started_at"
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

  create_table "solid_queue_blocked_executions", force: :cascade do |t|
    t.string "concurrency_key", null: false
    t.datetime "created_at", null: false
    t.datetime "expires_at", null: false
    t.bigint "job_id", null: false
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.index ["concurrency_key", "priority", "job_id"], name: "index_solid_queue_blocked_executions_for_release"
    t.index ["expires_at", "concurrency_key"], name: "index_solid_queue_blocked_executions_for_maintenance"
    t.index ["job_id"], name: "index_solid_queue_blocked_executions_on_job_id", unique: true
  end

  create_table "solid_queue_claimed_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.bigint "process_id"
    t.index ["job_id"], name: "index_solid_queue_claimed_executions_on_job_id", unique: true
    t.index ["process_id", "job_id"], name: "index_solid_queue_claimed_executions_on_process_id_and_job_id"
  end

  create_table "solid_queue_failed_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "error"
    t.bigint "job_id", null: false
    t.index ["job_id"], name: "index_solid_queue_failed_executions_on_job_id", unique: true
  end

  create_table "solid_queue_jobs", force: :cascade do |t|
    t.string "active_job_id"
    t.text "arguments"
    t.string "class_name", null: false
    t.string "concurrency_key"
    t.datetime "created_at", null: false
    t.datetime "finished_at"
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.datetime "scheduled_at"
    t.datetime "updated_at", null: false
    t.index ["active_job_id"], name: "index_solid_queue_jobs_on_active_job_id"
    t.index ["class_name"], name: "index_solid_queue_jobs_on_class_name"
    t.index ["finished_at"], name: "index_solid_queue_jobs_on_finished_at"
    t.index ["queue_name", "finished_at"], name: "index_solid_queue_jobs_for_filtering"
    t.index ["scheduled_at", "finished_at"], name: "index_solid_queue_jobs_for_alerting"
  end

  create_table "solid_queue_pauses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "queue_name", null: false
    t.index ["queue_name"], name: "index_solid_queue_pauses_on_queue_name", unique: true
  end

  create_table "solid_queue_processes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "hostname"
    t.string "kind", null: false
    t.datetime "last_heartbeat_at", null: false
    t.text "metadata"
    t.string "name", null: false
    t.integer "pid", null: false
    t.bigint "supervisor_id"
    t.index ["last_heartbeat_at"], name: "index_solid_queue_processes_on_last_heartbeat_at"
    t.index ["name", "supervisor_id"], name: "index_solid_queue_processes_on_name_and_supervisor_id", unique: true
    t.index ["supervisor_id"], name: "index_solid_queue_processes_on_supervisor_id"
  end

  create_table "solid_queue_ready_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.index ["job_id"], name: "index_solid_queue_ready_executions_on_job_id", unique: true
    t.index ["priority", "job_id"], name: "index_solid_queue_poll_all"
    t.index ["queue_name", "priority", "job_id"], name: "index_solid_queue_poll_by_queue"
  end

  create_table "solid_queue_recurring_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.datetime "run_at", null: false
    t.string "task_key", null: false
    t.index ["job_id"], name: "index_solid_queue_recurring_executions_on_job_id", unique: true
    t.index ["task_key", "run_at"], name: "index_solid_queue_recurring_executions_on_task_key_and_run_at", unique: true
  end

  create_table "solid_queue_recurring_tasks", force: :cascade do |t|
    t.text "arguments"
    t.string "class_name"
    t.string "command", limit: 2048
    t.datetime "created_at", null: false
    t.text "description"
    t.string "key", null: false
    t.integer "priority", default: 0
    t.string "queue_name"
    t.string "schedule", null: false
    t.boolean "static", default: true, null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_solid_queue_recurring_tasks_on_key", unique: true
    t.index ["static"], name: "index_solid_queue_recurring_tasks_on_static"
  end

  create_table "solid_queue_scheduled_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.datetime "scheduled_at", null: false
    t.index ["job_id"], name: "index_solid_queue_scheduled_executions_on_job_id", unique: true
    t.index ["scheduled_at", "priority", "job_id"], name: "index_solid_queue_dispatch_all"
  end

  create_table "solid_queue_semaphores", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "expires_at", null: false
    t.string "key", null: false
    t.datetime "updated_at", null: false
    t.integer "value", default: 1, null: false
    t.index ["expires_at"], name: "index_solid_queue_semaphores_on_expires_at"
    t.index ["key", "value"], name: "index_solid_queue_semaphores_on_key_and_value"
    t.index ["key"], name: "index_solid_queue_semaphores_on_key", unique: true
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
    t.boolean "beta_user", default: false
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "name"
    t.string "password_digest", null: false
    t.string "role"
    t.string "slack_user_id"
    t.datetime "updated_at", null: false
    t.string "user_type"
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
    t.string "plan_type"
    t.jsonb "settings"
    t.string "slack_access_token"
    t.string "slack_bot_token"
    t.datetime "slack_connected_at"
    t.string "slack_team_id"
    t.string "slack_team_name"
    t.string "slack_webhook_url"
    t.string "stripe_customer_id"
    t.string "stripe_subscription_id"
    t.integer "subscription_status"
    t.datetime "updated_at", null: false
    t.index ["slack_team_id"], name: "index_workspaces_on_slack_team_id"
    t.index ["stripe_customer_id"], name: "index_workspaces_on_stripe_customer_id"
    t.index ["stripe_subscription_id"], name: "index_workspaces_on_stripe_subscription_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "announcement_reads", "users"
  add_foreign_key "announcement_reads", "workspace_announcements"
  add_foreign_key "automations", "workspaces"
  add_foreign_key "channel_memberships", "channels"
  add_foreign_key "channel_memberships", "users"
  add_foreign_key "channels", "workspaces"
  add_foreign_key "chat_messages", "channels"
  add_foreign_key "chat_messages", "users"
  add_foreign_key "feature_votes", "feature_requests"
  add_foreign_key "feature_votes", "users"
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
  add_foreign_key "solid_queue_blocked_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_claimed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_failed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_ready_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_recurring_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_scheduled_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "user_achievements", "achievements"
  add_foreign_key "user_achievements", "users"
  add_foreign_key "user_stats", "users"
  add_foreign_key "users", "workspaces"
  add_foreign_key "workspace_announcements", "users"
  add_foreign_key "workspace_announcements", "workspaces"
  add_foreign_key "workspace_notes", "workspaces"
end
