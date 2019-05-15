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

ActiveRecord::Schema.define(version: 20190515025747) do

  create_table "branches", force: :cascade do |t|
    t.integer "branch_id"
    t.string "branch_name"
    t.boolean "branch_type"
    t.string "work_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "month_approvals", force: :cascade do |t|
    t.integer "user_id"
    t.date "work_month"
    t.integer "month_approval_status", default: 1
    t.integer "month_approver_id"
    t.string "note"
    t.string "checked"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_month_approvals_on_user_id"
  end

  create_table "over_approvals", force: :cascade do |t|
    t.integer "user_id"
    t.date "over_date"
    t.datetime "scheduled_over_time_out"
    t.integer "over_approval_status", default: 1
    t.integer "over_approver_id"
    t.string "checked_next_day"
    t.string "checked_confirm"
    t.string "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_over_approvals_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "basic_time", default: "2019-03-20 07:30:00"
    t.datetime "work_time", default: "2019-03-20 08:00:00"
    t.datetime "designed_time_in", default: "2019-03-20 09:00:00"
    t.datetime "designed_time_out", default: "2019-03-20 18:00:00"
    t.boolean "admin", default: false
    t.string "dep"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "card_id", default: "5555"
    t.integer "employee_id"
    t.boolean "sup", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "work_logs", force: :cascade do |t|
    t.integer "user_id"
    t.string "user_name"
    t.integer "work_change_approver_id"
    t.string "work_change_approver_name"
    t.boolean "work_change_approved?", default: false
    t.date "work_date"
    t.datetime "pre_time_in"
    t.datetime "pre_time_out"
    t.datetime "post_time_in"
    t.datetime "post_time_out"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_work_logs_on_user_id"
  end

  create_table "works", force: :cascade do |t|
    t.date "work_date"
    t.datetime "time_in"
    t.datetime "time_out"
    t.string "note"
    t.integer "work_change_status"
    t.integer "work_change_approver_id"
    t.string "checked_next_day"
    t.string "checked_confirm"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_works_on_user_id"
  end

end
