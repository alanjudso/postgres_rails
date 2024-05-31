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

ActiveRecord::Schema[7.0].define(version: 2024_05_31_164242) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "earnings", force: :cascade do |t|
    t.date "earning_date"
    t.decimal "amount"
    t.bigint "employee_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_earnings_on_employee_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "name"
    t.string "external_ref"
    t.bigint "employer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employer_id"], name: "index_employees_on_employer_id"
  end

  create_table "employer_csv_formats", force: :cascade do |t|
    t.string "external_ref_header"
    t.string "date_header"
    t.string "date_format"
    t.string "amount_header"
    t.string "amount_format"
    t.bigint "employer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employer_id"], name: "index_employer_csv_formats_on_employer_id"
  end

  create_table "employers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "earnings", "employees"
  add_foreign_key "employees", "employers"
  add_foreign_key "employer_csv_formats", "employers"
end
