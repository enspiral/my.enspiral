# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100723005904) do

  create_table "accounts", :force => true do |t|
    t.integer  "person_id"
    t.integer  "balance",    :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers", :force => true do |t|
    t.string   "name"
    t.text     "description"
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

  create_table "people", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "job_title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.string   "city"
    t.integer  "team_id"
    t.integer  "user_id"
    t.decimal  "base_commission", :precision => 10, :scale => 2, :default => 0.2
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "city"
  end

  create_table "projects_services", :id => false, :force => true do |t|
    t.integer "project_id"
    t.integer "service_id"
  end

  create_table "services", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "teams", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "city"
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
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
  end

  create_table "worked_ons", :force => true do |t|
    t.integer  "person_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

end
