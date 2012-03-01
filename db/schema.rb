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

ActiveRecord::Schema.define(:version => 20120301073305) do

  create_table "assignments", :force => true do |t|
    t.string   "name"
    t.integer  "atype"
    t.date     "assigned_date"
    t.date     "due_date"
    t.text     "content"
    t.integer  "p_o_a"
    t.integer  "out_of"
    t.integer  "classroom_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "classrooms", :force => true do |t|
    t.string   "name"
    t.string   "class_no"
    t.string   "section_no"
    t.string   "institution"
    t.integer  "dept_id"
    t.date     "date_start"
    t.date     "date_end"
    t.integer  "teacher_id"
    t.string   "schedule"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "classrooms_students", :id => false, :force => true do |t|
    t.integer  "classroom_id"
    t.integer  "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "depts", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "grades", :force => true do |t|
    t.integer  "score"
    t.integer  "assignment_id"
    t.integer  "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "simwords", :force => true do |t|
    t.integer  "simlable_id"
    t.string   "simlable_type"
    t.string   "word"
    t.integer  "size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "students", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "username"
    t.string   "password"
    t.string   "email"
    t.string   "major"
    t.string   "CellPhone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teachers", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "location"
    t.string   "department"
    t.string   "number"
    t.string   "office_hours"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
