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

ActiveRecord::Schema.define(version: 20190414121556) do

  create_table "admins", force: :cascade do |t|
    t.string   "username"
    t.string   "password_digest"
    t.integer  "fail_count"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["username"], name: "index_admins_on_username", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "game",        default: "Doom"
    t.index ["game"], name: "index_categories_on_game"
  end

  create_table "demo_files", force: :cascade do |t|
    t.integer  "wad_id"
    t.string   "data"
    t.string   "md5"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["md5"], name: "index_demo_files_on_md5"
    t.index ["wad_id"], name: "index_demo_files_on_wad_id"
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
    t.integer  "tas"
    t.integer  "guys"
    t.string   "level"
    t.datetime "recorded_at"
    t.text     "levelstat",      default: ""
    t.boolean  "has_tics"
    t.string   "engine"
    t.integer  "version",        default: 0
    t.integer  "wad_id"
    t.integer  "category_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "download_count", default: 0
    t.string   "video_link"
    t.integer  "demo_file_id"
    t.boolean  "has_hidden_tag", default: false
    t.boolean  "has_shown_tag",  default: false
    t.integer  "compatibility",  default: 0
    t.string   "kills"
    t.string   "items"
    t.string   "secrets"
    t.index ["category_id"], name: "index_demos_on_category_id"
    t.index ["demo_file_id"], name: "index_demos_on_demo_file_id"
    t.index ["recorded_at"], name: "index_demos_on_recorded_at"
    t.index ["wad_id", "level", "category_id", "tics"], name: "index_demos_on_wad_id_and_level_and_category_id_and_tics"
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
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "record_index", default: 0
    t.index ["name"], name: "index_players_on_name"
    t.index ["record_index"], name: "index_players_on_record_index"
    t.index ["username"], name: "index_players_on_username", unique: true
  end

  create_table "ports", force: :cascade do |t|
    t.string   "family"
    t.string   "version"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "data"
    t.string   "md5"
    t.index ["family", "version"], name: "index_ports_on_family_and_version", unique: true
    t.index ["md5"], name: "index_ports_on_md5", unique: true
  end

  create_table "sub_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.boolean  "show",       default: true
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

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "password_digest"
    t.string   "otp_secret"
    t.datetime "last_otp_at"
    t.boolean  "can_query",       default: false
    t.boolean  "can_mutate",      default: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "wad_files", force: :cascade do |t|
    t.integer  "iwad_id"
    t.string   "data"
    t.string   "md5"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["iwad_id"], name: "index_wad_files_on_iwad_id"
    t.index ["md5"], name: "index_wad_files_on_md5"
  end

  create_table "wads", force: :cascade do |t|
    t.string   "name"
    t.string   "username"
    t.string   "author"
    t.string   "year"
    t.string   "compatibility"
    t.boolean  "is_commercial"
    t.integer  "versions"
    t.integer  "iwad_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "single_map",    default: false
    t.integer  "wad_file_id"
    t.index ["iwad_id", "username"], name: "index_wads_on_iwad_id_and_username"
    t.index ["username"], name: "index_wads_on_username", unique: true
    t.index ["wad_file_id"], name: "index_wads_on_wad_file_id"
  end

end
