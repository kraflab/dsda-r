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

ActiveRecord::Schema.define(version: 20170204134550) do

  create_table "admins", force: :cascade do |t|
    t.string   "username"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["username"], name: "index_admins_on_username", unique: true
  end

  create_table "iwads", force: :cascade do |t|
    t.string   "name"
    t.string   "username"
    t.string   "author"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["username"], name: "index_iwads_on_username", unique: true
  end

  create_table "players", force: :cascade do |t|
    t.string   "name"
    t.string   "username"
    t.string   "twitch"
    t.string   "youtube"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["username"], name: "index_players_on_username", unique: true
  end

  create_table "ports", force: :cascade do |t|
    t.string   "file"
    t.string   "family"
    t.string   "version"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["family", "version"], name: "index_ports_on_family_and_version", unique: true
  end

  create_table "wads", force: :cascade do |t|
    t.string   "name"
    t.string   "username"
    t.string   "author"
    t.string   "file"
    t.integer  "iwad_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["iwad_id", "username"], name: "index_wads_on_iwad_id_and_username"
    t.index ["iwad_id"], name: "index_wads_on_iwad_id"
    t.index ["username"], name: "index_wads_on_username", unique: true
  end

end
