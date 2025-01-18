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

ActiveRecord::Schema[8.0].define(version: 2025_01_18_214612) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "reports", force: :cascade do |t|
    t.decimal "class_score"
    t.decimal "exam_score"
    t.decimal "total"
    t.string "grade"
    t.string "remarks"
    t.bigint "student_id", null: false
    t.bigint "subject_id", null: false
    t.bigint "semester_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["grade"], name: "index_reports_on_grade"
    t.index ["semester_id"], name: "index_reports_on_semester_id"
    t.index ["student_id"], name: "index_reports_on_student_id"
    t.index ["subject_id"], name: "index_reports_on_subject_id"
  end

  create_table "semesters", force: :cascade do |t|
    t.date "year"
    t.integer "term"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "students", force: :cascade do |t|
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.integer "current_basic"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subject_teachers", force: :cascade do |t|
    t.bigint "subject_id", null: false
    t.bigint "teacher_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subject_id", "teacher_id"], name: "index_subject_teachers_on_subject_id_and_teacher_id", unique: true
    t.index ["subject_id"], name: "index_subject_teachers_on_subject_id"
    t.index ["teacher_id"], name: "index_subject_teachers_on_teacher_id"
  end

  create_table "subjects", force: :cascade do |t|
    t.string "subject_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.integer "role", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "reports", "semesters"
  add_foreign_key "reports", "students"
  add_foreign_key "reports", "subjects"
  add_foreign_key "subject_teachers", "subjects"
  add_foreign_key "subject_teachers", "users", column: "teacher_id"
end
