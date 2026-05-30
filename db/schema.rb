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

ActiveRecord::Schema[7.2].define(version: 2026_05_30_010156) do
  create_table "odontograms", force: :cascade do |t|
    t.integer "patient_id", null: false
    t.string "odontogram_type", default: "adult", null: false
    t.integer "version", default: 1, null: false
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id", "version"], name: "index_odontograms_on_patient_id_and_version", unique: true
    t.index ["patient_id"], name: "index_odontograms_on_patient_id"
  end

  create_table "patients", force: :cascade do |t|
    t.string "name", null: false
    t.date "birth_date"
    t.string "phone"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_patients_on_name"
  end

  create_table "state_histories", force: :cascade do |t|
    t.integer "odontogram_id", null: false
    t.integer "tooth_state_id"
    t.string "tooth_number", null: false
    t.string "face", null: false
    t.string "old_state"
    t.string "new_state", null: false
    t.integer "user_id"
    t.datetime "changed_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["changed_at"], name: "index_state_histories_on_changed_at"
    t.index ["odontogram_id"], name: "index_state_histories_on_odontogram_id"
    t.index ["tooth_state_id"], name: "index_state_histories_on_tooth_state_id"
    t.index ["user_id"], name: "index_state_histories_on_user_id"
  end

  create_table "tooth_states", force: :cascade do |t|
    t.integer "odontogram_id", null: false
    t.string "tooth_number", null: false
    t.string "face", default: "whole", null: false
    t.string "state", default: "healthy", null: false
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["odontogram_id", "tooth_number", "face"], name: "idx_tooth_states_on_odonto_tooth_face", unique: true
    t.index ["odontogram_id"], name: "index_tooth_states_on_odontogram_id"
  end

  add_foreign_key "odontograms", "patients"
  add_foreign_key "state_histories", "odontograms"
  add_foreign_key "state_histories", "tooth_states"
  add_foreign_key "tooth_states", "odontograms"
end
