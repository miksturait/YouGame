# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130810185151) do

  create_table "achievements", :force => true do |t|
    t.string   "type",                          :null => false
    t.integer  "tracker_id"
    t.string   "name"
    t.string   "message"
    t.integer  "exp_points",     :default => 0
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "mineral_points", :default => 0
    t.string   "symbol"
  end

  create_table "assets", :force => true do |t|
    t.string   "file"
    t.integer  "subject_id"
    t.string   "subject_type"
    t.datetime "uploaded_at"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "audits", :force => true do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "associated_id"
    t.string   "associated_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "audited_changes"
    t.integer  "version",         :default => 0
    t.string   "comment"
    t.string   "remote_address"
    t.datetime "created_at"
  end

  add_index "audits", ["associated_id", "associated_type"], :name => "associated_index"
  add_index "audits", ["auditable_id", "auditable_type"], :name => "auditable_index"
  add_index "audits", ["created_at"], :name => "index_audits_on_created_at"
  add_index "audits", ["user_id", "user_type"], :name => "user_index"

  create_table "tracker_api_points_requests", :force => true do |t|
    t.integer  "tracker_id",         :null => false
    t.string   "email",              :null => false
    t.string   "for"
    t.integer  "exp_points",         :null => false
    t.integer  "mineral_points",     :null => false
    t.string   "related_url"
    t.string   "achievement_symbol"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "tracker_groups", :force => true do |t|
    t.integer  "tracker_id",  :null => false
    t.string   "name",        :null => false
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "tracker_issues", :force => true do |t|
    t.integer  "tracker_id",                          :null => false
    t.integer  "project_id",                          :null => false
    t.integer  "updater_id",                          :null => false
    t.integer  "reporter_id",                         :null => false
    t.integer  "assignee_id"
    t.string   "issue_id",                            :null => false
    t.string   "summary",                             :null => false
    t.string   "project_short_name"
    t.string   "number_in_project"
    t.text     "description"
    t.string   "created"
    t.string   "updated"
    t.string   "updater_name"
    t.string   "updater_full_name"
    t.string   "resolved"
    t.string   "reporter_name"
    t.string   "reporter_full_name"
    t.string   "state"
    t.string   "assignee"
    t.string   "type"
    t.string   "priority"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.string   "difficulty"
    t.float    "reopen_factor",      :default => 1.0, :null => false
  end

  create_table "tracker_levels", :force => true do |t|
    t.string   "planet_name"
    t.string   "brood_name"
    t.string   "mineral_name"
    t.date     "month"
    t.integer  "tracker_id"
    t.integer  "target"
    t.datetime "completed_at"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "tracker_member_groups", :force => true do |t|
    t.integer  "group_id",   :null => false
    t.integer  "member_id",  :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tracker_member_projects", :force => true do |t|
    t.integer  "project_id", :null => false
    t.integer  "member_id",  :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tracker_members", :force => true do |t|
    t.integer  "tracker_id",                              :null => false
    t.string   "login",                                   :null => false
    t.string   "full_name",                               :null => false
    t.string   "email"
    t.time     "last_access"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.boolean  "admin",                :default => false, :null => false
    t.datetime "stamina_recovered_at"
  end

  create_table "tracker_points_obtains", :force => true do |t|
    t.integer  "member_id",                     :null => false
    t.integer  "tracker_id",                    :null => false
    t.integer  "exp_points",     :default => 0, :null => false
    t.integer  "subject_id"
    t.string   "subject_type"
    t.string   "description"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "mineral_points", :default => 0
  end

  create_table "tracker_projects", :force => true do |t|
    t.integer  "tracker_id",  :null => false
    t.string   "name",        :null => false
    t.string   "project_id",  :null => false
    t.string   "description"
    t.string   "lead"
    t.integer  "lead_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "tracker_reports", :force => true do |t|
    t.integer  "tracker_id",                  :null => false
    t.text     "message",     :default => "", :null => false
    t.integer  "project_id",                  :null => false
    t.integer  "creator_id",                  :null => false
    t.string   "report_date",                 :null => false
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "trackers", :force => true do |t|
    t.string       "url",                                        :null => false
    t.string       "state",                                      :null => false
    t.string       "username"
    t.string       "password"
    t.string       "admin_username"
    t.string       "admin_password"
    t.string       "issue_accepted_state"
    t.string       "role_name"
    t.datetime     "last_sync_at"
    t.datetime     "last_user_activity_at"
    t.datetime     "created_at",                                 :null => false
    t.datetime     "updated_at",                                 :null => false
    t.string       "issue_in_progress_state"
    t.string       "issue_backlog_state"
    t.string_array "hidden_project_ids"
    t.string_array "hidden_member_ids"
    t.string_array "hidden_group_ids"
    t.datetime     "last_full_sync_at"
    t.boolean      "broadcast_required",      :default => false
    t.string       "issue_difficulty_field"
    t.text         "last_broadcast",          :default => "{}"
    t.string       "api_key"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",   :null => false
    t.string   "encrypted_password",     :default => "",   :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "tracker_member_id"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.boolean  "receive_emails",         :default => true, :null => false
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
