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

ActiveRecord::Schema.define(version: 20170216025240) do

  create_table "admins", force: :cascade do |t|
    t.string   "username"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["username"], name: "index_admins_on_username", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "demo_players", force: :cascade do |t|
    t.integer  "demo_id"
    t.integer  "player_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["demo_id", "player_id"], name: "index_demo_players_on_demo_id_and_player_id", unique: true
    t.index ["demo_id"], name: "index_demo_players_on_demo_id"
    t.index ["player_id"], name: "index_demo_players_on_player_id"
  end

  create_table "demos", force: :cascade do |t|
    t.integer  "tics"
    t.integer  "complevel"
    t.integer  "tas"
    t.integer  "guys"
    t.string   "level"
    t.datetime "recorded_at"
    t.text     "levelstat"
    t.string   "file"
    t.integer  "wad_id"
    t.integer  "category_id"
    t.integer  "port_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["category_id"], name: "index_demos_on_category_id"
    t.index ["port_id"], name: "index_demos_on_port_id"
    t.index ["wad_id", "level", "category_id", "tics"], name: "index_demos_on_wad_id_and_level_and_category_id_and_tics"
    t.index ["wad_id"], name: "index_demos_on_wad_id"
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

  create_table "sub_categories", force: :cascade do |t|
    t.string   "name"
    t.integer  "style"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.integer  "sub_category_id"
    t.integer  "demo_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["demo_id"], name: "index_tags_on_demo_id"
    t.index ["sub_category_id", "demo_id"], name: "index_tags_on_sub_category_id_and_demo_id", unique: true
    t.index ["sub_category_id"], name: "index_tags_on_sub_category_id"
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
