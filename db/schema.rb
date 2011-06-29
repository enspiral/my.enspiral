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

ActiveRecord::Schema.define(:version => 20110628230145) do

  create_table "accounts", :force => true do |t|
    t.integer  "person_id"
    t.decimal  "balance",    :precision => 10, :scale => 2, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "badge_ownerships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "badge_id"
    t.text     "reason"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "person_id"
  end

  create_table "badges", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by"
    t.string   "image"
  end

  create_table "cities", :force => true do |t|
    t.integer  "country_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.integer  "person_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
  end

  create_table "feed_entries", :force => true do |t|
    t.string   "feed_id"
    t.string   "title"
    t.string   "url"
    t.string   "author"
    t.string   "summary"
    t.text     "content"
    t.datetime "published"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoice_allocations", :force => true do |t|
    t.integer  "person_id"
    t.integer  "invoice_id"
    t.decimal  "amount",     :precision => 10, :scale => 2
    t.string   "currency"
    t.boolean  "disbursed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "commission", :precision => 10, :scale => 2, :default => 0.2
    t.decimal  "hours",      :precision => 10, :scale => 2, :default => 0.0
  end

  create_table "invoices", :force => true do |t|
    t.integer  "customer_id"
    t.decimal  "amount",      :precision => 10, :scale => 2
    t.string   "currency"
    t.boolean  "paid"
    t.date     "date"
    t.date     "due"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "number"
  end

  create_table "notices", :force => true do |t|
    t.integer  "person_id"
    t.string   "summary"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "job_title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.integer  "user_id"
    t.decimal  "base_commission", :precision => 10, :scale => 2, :default => 0.2
    t.boolean  "has_gravatar",                                   :default => false
    t.integer  "country_id"
    t.integer  "city_id"
    t.boolean  "featured",                                       :default => false
    t.boolean  "contact",                                        :default => false
    t.string   "phone"
    t.boolean  "public",                                         :default => false
    t.string   "twitter"
    t.string   "skype"
    t.boolean  "active",                                         :default => true
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "customer_id"
    t.integer  "person_id"
    t.decimal  "budget",      :precision => 10, :scale => 2
    t.date     "due_date"
    t.string   "image"
  end

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
    t.string   "email",                :default => "",   :null => false
    t.string   "encrypted_password"
    t.string   "password_salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",      :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.boolean  "active",               :default => true
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

end
