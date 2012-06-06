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

ActiveRecord::Schema.define(:version => 20120606055430) do

  create_table "accounts", :force => true do |t|
    t.decimal  "balance",     :precision => 10, :scale => 2, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "category"
    t.boolean  "active",                                     :default => true
    t.boolean  "public",                                     :default => false, :null => false
    t.boolean  "closed",                                     :default => false, :null => false
    t.decimal  "min_balance", :precision => 10, :scale => 0, :default => 0,     :null => false
    t.integer  "company_id",                                                    :null => false
  end

  create_table "accounts_people", :force => true do |t|
    t.integer  "account_id"
    t.integer  "person_id"
    t.string   "role"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "blog_posts", :force => true do |t|
    t.integer  "blog_id"
    t.string   "title"
    t.string   "author"
    t.text     "summary"
    t.string   "url"
    t.datetime "posted_at"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "post_id"
  end

  create_table "blogs", :force => true do |t|
    t.integer  "person_id"
    t.integer  "company_id"
    t.string   "url"
    t.string   "feed_url"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "cities", :force => true do |t|
    t.integer  "country_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.integer  "income_account_id"
    t.integer  "support_account_id"
    t.decimal  "default_contribution", :precision => 10, :scale => 2, :default => 0.2
    t.datetime "created_at",                                                            :null => false
    t.datetime "updated_at",                                                            :null => false
    t.string   "slug"
    t.string   "image_uid"
    t.boolean  "active",                                              :default => true, :null => false
    t.integer  "country_id"
    t.text     "about"
    t.string   "website"
    t.string   "twitter"
    t.string   "facebook"
    t.string   "linkedin"
    t.integer  "city_id"
    t.string   "contact_name"
    t.string   "contact_phone"
    t.string   "contact_email"
    t.string   "contact_skype"
    t.text     "address"
    t.string   "tagline"
  end

  add_index "companies", ["active"], :name => "index_companies_on_active"
  add_index "companies", ["slug"], :name => "index_companies_on_slug", :unique => true

  create_table "company_memberships", :force => true do |t|
    t.integer  "company_id"
    t.integer  "person_id"
    t.boolean  "admin"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "role"
  end

  add_index "company_memberships", ["company_id"], :name => "index_company_memberships_on_company_id"
  add_index "company_memberships", ["person_id"], :name => "index_company_memberships_on_person_id"

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
  end

  create_table "featured_items", :force => true do |t|
    t.boolean  "published",     :default => false, :null => false
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  create_table "feed_entries", :force => true do |t|
    t.string   "feed_id"
    t.string   "title"
    t.string   "url"
    t.string   "author"
    t.text     "summary"
    t.text     "content"
    t.datetime "published"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "funds_transfer_template_lines", :force => true do |t|
    t.integer  "funds_transfer_template_id"
    t.integer  "source_account_id"
    t.integer  "destination_account_id"
    t.decimal  "amount",                     :precision => 10, :scale => 0
    t.datetime "created_at",                                                :null => false
    t.datetime "updated_at",                                                :null => false
  end

  add_index "funds_transfer_template_lines", ["funds_transfer_template_id"], :name => "fttlftt_id"
  add_index "funds_transfer_template_lines", ["source_account_id", "destination_account_id", "funds_transfer_template_id"], :name => "source_dest_unique_per_ft", :unique => true

  create_table "funds_transfer_templates", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "company_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "funds_transfer_templates", ["company_id"], :name => "index_funds_transfer_templates_on_company_id"

  create_table "funds_transfers", :force => true do |t|
    t.integer  "author_id"
    t.decimal  "amount",                     :precision => 10, :scale => 0
    t.integer  "source_account_id"
    t.integer  "destination_account_id"
    t.integer  "source_transaction_id"
    t.integer  "destination_transaction_id"
    t.string   "description"
    t.datetime "created_at",                                                :null => false
    t.datetime "updated_at",                                                :null => false
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "invoice_allocations", :force => true do |t|
    t.integer  "person_id"
    t.integer  "invoice_id"
    t.decimal  "amount",             :precision => 10, :scale => 2
    t.string   "currency"
    t.boolean  "disbursed",                                         :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "contribution",       :precision => 10, :scale => 2, :default => 0.2
    t.decimal  "hours",              :precision => 10, :scale => 2, :default => 0.0
    t.integer  "account_id"
    t.integer  "company_commission"
  end

  create_table "invoices", :force => true do |t|
    t.integer  "customer_id"
    t.decimal  "amount",         :precision => 10, :scale => 2
    t.string   "currency"
    t.boolean  "paid",                                          :default => false, :null => false
    t.date     "date"
    t.date     "due"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "number"
    t.integer  "project_id"
    t.string   "xero_reference"
    t.boolean  "disbursed",                                     :default => false, :null => false
    t.integer  "company_id"
  end

  create_table "payments", :force => true do |t|
    t.decimal  "amount",         :precision => 10, :scale => 2
    t.date     "paid_on"
    t.integer  "invoice_id"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.integer  "author_id"
    t.integer  "transaction_id"
  end

  create_table "people", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "job_title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.integer  "user_id"
    t.decimal  "base_commission",            :precision => 10, :scale => 2, :default => 0.2
    t.boolean  "has_gravatar",                                              :default => false
    t.integer  "country_id"
    t.integer  "city_id"
    t.boolean  "contact",                                                   :default => false
    t.string   "phone"
    t.boolean  "public",                                                    :default => false
    t.string   "twitter"
    t.string   "skype"
    t.boolean  "active",                                                    :default => true
    t.string   "relationship_with_enspiral"
    t.string   "employment_status"
    t.string   "desired_employment_status"
    t.integer  "baseline_income"
    t.integer  "ideal_income"
    t.integer  "default_hours_available"
    t.string   "profile_image"
    t.string   "image_uid"
    t.string   "slug"
    t.decimal  "rate",                       :precision => 10, :scale => 0
    t.text     "about"
    t.string   "facebook"
    t.string   "linkedin"
    t.boolean  "published"
    t.string   "tagline"
  end

  add_index "people", ["slug"], :name => "index_people_on_slug", :unique => true

  create_table "people_groups", :force => true do |t|
    t.integer  "group_id"
    t.integer  "person_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "people_skills", :force => true do |t|
    t.integer  "skill_id"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_bookings", :force => true do |t|
    t.date     "week"
    t.integer  "time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_membership_id"
  end

  add_index "project_bookings", ["project_membership_id", "week"], :name => "index_project_bookings_on_project_membership_id_and_week", :unique => true

  create_table "project_memberships", :force => true do |t|
    t.integer  "person_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_lead"
    t.string   "role"
  end

  add_index "project_memberships", ["project_id", "person_id"], :name => "index_project_memberships_on_project_id_and_person_id", :unique => true

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "customer_id"
    t.decimal  "budget",        :precision => 10, :scale => 2
    t.date     "due_date"
    t.string   "status"
    t.integer  "account_id"
    t.integer  "company_id"
    t.string   "slug"
    t.string   "image_uid"
    t.string   "tagline"
    t.decimal  "amount_quoted", :precision => 10, :scale => 2
  end

  add_index "projects", ["slug"], :name => "index_projects_on_slug", :unique => true

  create_table "service_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "services", :force => true do |t|
    t.integer  "person_id"
    t.integer  "service_category_id"
    t.text     "description"
    t.float    "rate"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "skills", :force => true do |t|
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transactions", :force => true do |t|
    t.integer  "account_id"
    t.integer  "creator_id"
    t.decimal  "amount",      :precision => 10, :scale => 2
    t.string   "description"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email",                                    :null => false
    t.string   "encrypted_password"
    t.string   "password_salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
    t.string   "reset_password_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",        :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.boolean  "active",                 :default => true
    t.datetime "reset_password_sent_at"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

end
