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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140203203637) do

  create_table "companies", force: true do |t|
    t.string   "name"
    t.string   "kt",                limit: 10
    t.text     "comments"
    t.string   "email"
    t.string   "tel"
    t.string   "mobile"
    t.string   "fax"
    t.text     "contact_name"
    t.string   "address1"
    t.string   "address2"
    t.string   "postcode"
    t.string   "city"
    t.string   "shipping_address1"
    t.string   "shipping_address2"
    t.string   "shipping_postcode"
    t.string   "shipping_city"
    t.boolean  "enabled",                      default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "logins", force: true do |t|
    t.integer  "user_id"
    t.text     "useragent"
    t.binary   "ip_addr"
    t.boolean  "success"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "logins", ["user_id"], name: "index_logins_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "fullname"
    t.string   "email"
    t.text     "password_hash"
    t.string   "password_seed"
    t.string   "recovery_code"
    t.datetime "recovery_expires"
    t.integer  "access"
    t.text     "comments"
    t.boolean  "enabled",          default: true
    t.text     "remember_hash"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["company_id"], name: "index_users_on_company_id", using: :btree

end
