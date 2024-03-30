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

ActiveRecord::Schema[7.1].define(version: 2024_03_30_011045) do
  create_table "condition_groups", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "logical_operator", null: false
    t.integer "parent_condition_group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_condition_group_id"], name: "index_condition_groups_on_parent_condition_group_id"
    t.index ["user_id"], name: "index_condition_groups_on_user_id"
  end

  create_table "conditions", force: :cascade do |t|
    t.integer "condition_group_id", null: false
    t.string "comparison_operator", null: false
    t.string "comparison_value"
    t.string "lower_bound"
    t.string "upper_bound"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["condition_group_id"], name: "index_conditions_on_condition_group_id"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "mailbox_message_parsers", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name"
    t.integer "match_condition_group_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["match_condition_group_id"], name: "index_mailbox_message_parsers_on_match_condition_group_id"
    t.index ["user_id"], name: "index_mailbox_message_parsers_on_user_id"
  end

  create_table "mailbox_messages", force: :cascade do |t|
    t.integer "mailbox_sender_id", null: false
    t.bigint "uid", null: false
    t.string "message_id"
    t.text "body", null: false
    t.string "content_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "subject"
    t.index ["mailbox_sender_id"], name: "index_mailbox_messages_on_mailbox_sender_id"
  end

  create_table "mailbox_senders", force: :cascade do |t|
    t.integer "mailbox_id", null: false
    t.string "name", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0, null: false
    t.index ["mailbox_id", "email"], name: "index_mailbox_senders_on_mailbox_id_and_email", unique: true
    t.index ["mailbox_id"], name: "index_mailbox_senders_on_mailbox_id"
  end

  create_table "mailboxes", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_mailboxes_on_email", unique: true
    t.index ["user_id"], name: "index_mailboxes_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "condition_groups", "condition_groups", column: "parent_condition_group_id"
  add_foreign_key "condition_groups", "users"
  add_foreign_key "conditions", "condition_groups"
  add_foreign_key "mailbox_message_parsers", "condition_groups", column: "match_condition_group_id"
  add_foreign_key "mailbox_message_parsers", "users"
  add_foreign_key "mailbox_messages", "mailbox_senders"
  add_foreign_key "mailbox_senders", "mailboxes"
  add_foreign_key "mailboxes", "users"
end
