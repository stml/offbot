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

ActiveRecord::Schema.define(:version => 20120521112527) do

  create_table "email_messages", :force => true do |t|
    t.string    "message_id"
    t.timestamp "response_timestap"
    t.integer   "project_id"
    t.integer   "person_id"
    t.timestamp "created_at",        :null => false
    t.timestamp "updated_at",        :null => false
  end

  create_table "invitations", :force => true do |t|
    t.string    "email"
    t.timestamp "created_at", :null => false
    t.timestamp "updated_at", :null => false
  end

  create_table "invitations_projects", :id => false, :force => true do |t|
    t.integer "invitation_id"
    t.integer "project_id"
  end

  create_table "people", :force => true do |t|
    t.string    "name"
    t.string    "email"
    t.timestamp "created_at",                             :null => false
    t.timestamp "updated_at",                             :null => false
    t.integer   "project_id"
    t.string    "encrypted_password",     :default => "", :null => false
    t.string    "reset_password_token"
    t.timestamp "reset_password_sent_at"
    t.timestamp "remember_created_at"
    t.integer   "sign_in_count",          :default => 0
    t.timestamp "current_sign_in_at"
    t.timestamp "last_sign_in_at"
    t.string    "current_sign_in_ip"
    t.string    "last_sign_in_ip"
    t.string    "confirmation_token"
    t.timestamp "confirmed_at"
    t.timestamp "confirmation_sent_at"
    t.string    "unconfirmed_email"
    t.integer   "project_admins_list_id"
    t.boolean   "is_superadmin"
    t.string    "email_key"
  end

  add_index "people", ["email"], :name => "index_people_on_email", :unique => true
  add_index "people", ["reset_password_token"], :name => "index_people_on_reset_password_token", :unique => true

  create_table "people_projects", :id => false, :force => true do |t|
    t.integer "person_id"
    t.integer "project_id"
  end

  create_table "project_admins_lists", :force => true do |t|
    t.integer   "project_id"
    t.timestamp "created_at", :null => false
    t.timestamp "updated_at", :null => false
  end

  create_table "projects", :force => true do |t|
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.string   "name"
    t.integer  "created_by"
    t.string   "weekly_digest_day"
    t.datetime "weekly_digest_sent_at"
    t.integer  "frequency"
  end

  create_table "scheduled_request_dates", :force => true do |t|
    t.integer  "person_id"
    t.integer  "project_id"
    t.datetime "request_date"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "scheduled_request_dates", ["person_id"], :name => "index_scheduled_request_dates_on_person_id"
  add_index "scheduled_request_dates", ["project_id"], :name => "index_scheduled_request_dates_on_project_id"

  create_table "taggings", :force => true do |t|
    t.integer   "tag_id"
    t.integer   "taggable_id"
    t.string    "taggable_type"
    t.integer   "tagger_id"
    t.string    "tagger_type"
    t.string    "context",       :limit => 128
    t.timestamp "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "updates", :force => true do |t|
    t.text      "body"
    t.timestamp "created_at",       :null => false
    t.timestamp "updated_at",       :null => false
    t.integer   "person_id"
    t.integer   "project_id"
    t.integer   "email_message_id"
  end

end
