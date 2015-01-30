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

ActiveRecord::Schema.define(:version => 20150130203205) do

  create_table "activities", :force => true do |t|
    t.text     "text"
    t.string   "type"
    t.integer  "challenge_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "title"
  end

  create_table "admins", :force => true do |t|
    t.string   "email",              :default => "", :null => false
    t.string   "encrypted_password", :default => "", :null => false
    t.integer  "sign_in_count",      :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",    :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "admins", ["email"], :name => "index_admins_on_email", :unique => true

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "public_url"
    t.string   "oauth_token"
  end

  add_index "authentications", ["user_id"], :name => "index_authentications_on_user_id"

  create_table "challenges", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "creator_id"
    t.string   "status",                       :default => "open"
    t.string   "dataset_url"
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
    t.integer  "likes_counter",                :default => 0
    t.text     "first_spec"
    t.text     "second_spec"
    t.text     "third_spec"
    t.string   "pitch"
    t.text     "additional_links"
    t.string   "avatar"
    t.text     "about"
    t.integer  "organization_id"
    t.text     "welcome_mail"
    t.string   "dataset_id"
    t.string   "entry_template_url"
    t.string   "infographic"
    t.date     "ideas_phase_due_on"
    t.date     "ideas_selection_phase_due_on"
    t.date     "prototypes_phase_due_on"
    t.text     "prize"
    t.date     "starts_on"
    t.text     "fourth_spec"
    t.text     "fifth_spec"
    t.date     "finish_on"
    t.string   "assessment_methodology"
    t.text     "evaluation_criteria"
  end

  add_index "challenges", ["organization_id"], :name => "index_challenges_on_organization_id"

  create_table "collaborations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "challenge_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "member_id"
  end

  add_index "collaborations", ["member_id"], :name => "index_collaborations_on_member_id"

  create_table "comments", :force => true do |t|
    t.integer  "commentable_id",   :default => 0
    t.string   "commentable_type", :default => ""
    t.text     "body",             :default => ""
    t.integer  "user_id",          :default => 0,  :null => false
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.integer  "votes_counter",    :default => 0
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "datasets", :force => true do |t|
    t.integer  "challenge_id"
    t.string   "guid"
    t.string   "format"
    t.string   "title"
    t.string   "name"
    t.string   "notes"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "datasets", ["guid"], :name => "index_datasets_on_guid"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "entries", :force => true do |t|
    t.string   "name"
    t.string   "live_demo_url"
    t.text     "description"
    t.integer  "member_id"
    t.integer  "challenge_id"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.text     "technologies"
    t.boolean  "public",            :default => false, :null => false
    t.string   "image"
    t.boolean  "accepted"
    t.string   "idea_url"
    t.string   "letter_under_oath"
    t.string   "repo_url"
    t.string   "demo_url"
    t.integer  "winner"
    t.boolean  "is_valid",          :default => true
  end

  create_table "evaluations", :force => true do |t|
    t.integer  "challenge_id"
    t.integer  "judge_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "judges", :force => true do |t|
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "company_name"
  end

  create_table "members", :force => true do |t|
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
    t.string   "company_name"
    t.string   "company_rfc"
    t.string   "company_charter"
    t.string   "company_president"
    t.boolean  "phase_finish_reminder_setting", :default => true, :null => false
  end

  create_table "organizations", :force => true do |t|
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.boolean  "accredited",            :default => false
    t.boolean  "accepting_subscribers", :default => false
    t.string   "slug"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "skills", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "subscribers", :force => true do |t|
    t.string   "email"
    t.integer  "organization_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "subscribers", ["organization_id"], :name => "index_subscribers_on_organization_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "avatar"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.string   "nickname"
    t.string   "bio"
    t.string   "role",                   :default => "member"
    t.string   "userable_type"
    t.integer  "userable_id"
    t.string   "encrypted_password",     :default => "",       :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "website"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["userable_id"], :name => "index_users_on_userable_id"
  add_index "users", ["userable_type"], :name => "index_users_on_userable_type"

  create_table "userskills", :force => true do |t|
    t.integer  "user_id"
    t.integer  "skill_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "userskills", ["skill_id"], :name => "index_userskills_on_skill_id"
  add_index "userskills", ["user_id"], :name => "index_userskills_on_user_id"

  create_table "votes", :force => true do |t|
    t.boolean  "vote",          :default => false, :null => false
    t.integer  "voteable_id",                      :null => false
    t.string   "voteable_type",                    :null => false
    t.integer  "voter_id"
    t.string   "voter_type"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "votes", ["voteable_id", "voteable_type"], :name => "index_votes_on_voteable_id_and_voteable_type"
  add_index "votes", ["voter_id", "voter_type", "voteable_id", "voteable_type"], :name => "fk_one_vote_per_user_per_entity", :unique => true
  add_index "votes", ["voter_id", "voter_type"], :name => "index_votes_on_voter_id_and_voter_type"

end
