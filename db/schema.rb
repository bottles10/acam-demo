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

ActiveRecord::Schema[8.0].define(version: 2025_01_26_021804) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "assessments", force: :cascade do |t|
    t.integer "attendance_present"
    t.integer "attendance_total"
    t.string "attitude"
    t.string "conduct"
    t.string "interest"
    t.string "class_teacher_remarks"
    t.string "form_master"
    t.bigint "student_id", null: false
    t.bigint "semester_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "next_basic_level"
    t.index ["semester_id"], name: "index_assessments_on_semester_id"
    t.index ["student_id"], name: "index_assessments_on_student_id"
  end

  create_table "cutoffs", force: :cascade do |t|
    t.string "current_basic"
    t.integer "class_percentage"
    t.integer "exam_percentage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "school_id", null: false
    t.index ["school_id"], name: "index_cutoffs_on_school_id"
  end

  create_table "reports", force: :cascade do |t|
    t.decimal "exam_score"
    t.decimal "total"
    t.integer "grade"
    t.string "remarks"
    t.bigint "student_id", null: false
    t.bigint "subject_id", null: false
    t.bigint "semester_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "class_scores"
    t.index ["grade"], name: "index_reports_on_grade"
    t.index ["semester_id"], name: "index_reports_on_semester_id"
    t.index ["student_id"], name: "index_reports_on_student_id"
    t.index ["subject_id"], name: "index_reports_on_subject_id"
  end

  create_table "schools", force: :cascade do |t|
    t.string "name"
    t.string "subdomain"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subdomain"], name: "index_schools_on_subdomain", unique: true
  end

  create_table "semesters", force: :cascade do |t|
    t.date "year"
    t.integer "term"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "school_id", null: false
    t.index ["school_id"], name: "index_semesters_on_school_id"
    t.index ["year", "term"], name: "index_semesters_on_year_and_term", unique: true
  end

  create_table "students", force: :cascade do |t|
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.integer "current_basic"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "school_id", null: false
    t.index ["current_basic"], name: "index_students_on_current_basic"
    t.index ["school_id"], name: "index_students_on_school_id"
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
    t.bigint "school_id", null: false
    t.index ["school_id"], name: "index_subjects_on_school_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.integer "role", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.bigint "school_id", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["school_id"], name: "index_users_on_school_id"
  end

  add_foreign_key "assessments", "semesters"
  add_foreign_key "assessments", "students"
  add_foreign_key "cutoffs", "schools"
  add_foreign_key "reports", "semesters"
  add_foreign_key "reports", "students"
  add_foreign_key "reports", "subjects"
  add_foreign_key "semesters", "schools"
  add_foreign_key "students", "schools"
  add_foreign_key "subject_teachers", "subjects"
  add_foreign_key "subject_teachers", "users", column: "teacher_id"
  add_foreign_key "subjects", "schools"
  add_foreign_key "users", "schools"
end
