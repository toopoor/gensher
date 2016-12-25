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

ActiveRecord::Schema.define(version: 20140628214610) do

  create_table "ban", force: true do |t|
    t.integer   "user_id",            null: false
    t.integer   "comp_id",            null: false
    t.string    "ip",      limit: 16, null: false
    t.string    "ip2",     limit: 32, null: false
    t.timestamp "date",               null: false
  end

  create_table "collage", id: false, force: true do |t|
    t.integer   "id",                        null: false
    t.integer   "userid",                    null: false
    t.boolean   "collage_type",              null: false
    t.string    "content",      limit: 1000, null: false
    t.timestamp "date",                      null: false
  end

  create_table "comps", force: true do |t|
    t.string    "key",     limit: 32, null: false
    t.string    "ip",      limit: 16, null: false
    t.string    "ip2",     limit: 32, null: false
    t.string    "os",      limit: 16, null: false
    t.string    "browser", limit: 16, null: false
    t.timestamp "date",               null: false
  end

  add_index "comps", ["date"], name: "date", using: :btree
  add_index "comps", ["key"], name: "key", using: :btree

  create_table "emails", force: true do |t|
    t.integer   "comp_id",             null: false
    t.integer   "iduser",              null: false
    t.string    "oldemail", limit: 64, null: false
    t.string    "newemail", limit: 64, null: false
    t.string    "fio",      limit: 64, null: false
    t.timestamp "date",                null: false
  end

  create_table "events", force: true do |t|
    t.integer   "userid",             null: false
    t.string    "event",  limit: 125, null: false
    t.boolean   "status",             null: false
    t.timestamp "date",               null: false
  end

  add_index "events", ["userid"], name: "userid", using: :btree

  create_table "friend", force: true do |t|
    t.integer   "userid", null: false
    t.integer   "friend", null: false
    t.timestamp "date",   null: false
  end

  add_index "friend", ["date"], name: "date", using: :btree
  add_index "friend", ["friend"], name: "frend", using: :btree
  add_index "friend", ["userid"], name: "userid", using: :btree

  create_table "ip_login", force: true do |t|
    t.string    "host",      limit: 64, null: false
    t.integer   "comp_id",              null: false
    t.string    "ip",        limit: 16, null: false
    t.string    "ip2",       limit: 32, null: false
    t.string    "os",        limit: 16, null: false
    t.string    "browser",   limit: 16, null: false
    t.string    "login",     limit: 64, null: false
    t.string    "pass",      limit: 64, null: false
    t.boolean   "status",               null: false
    t.timestamp "date",                 null: false
    t.string    "key",       limit: 32, null: false
    t.boolean   "soc_share",            null: false
  end

  add_index "ip_login", ["date"], name: "date", using: :btree
  add_index "ip_login", ["ip"], name: "ip", using: :btree
  add_index "ip_login", ["login"], name: "login", using: :btree
  add_index "ip_login", ["status"], name: "status", using: :btree

  create_table "list", force: true do |t|
    t.integer   "userid",               null: false
    t.string    "fio",     limit: 60,   null: false
    t.string    "sms_tel", limit: 16,   null: false
    t.string    "email",   limit: 64,   null: false
    t.string    "skype",   limit: 32,   null: false
    t.string    "info",    limit: 500,  null: false
    t.string    "contact", limit: 1020, null: false
    t.string    "key",     limit: 32,   null: false
    t.timestamp "date",                 null: false
  end

  add_index "list", ["email"], name: "email", using: :btree
  add_index "list", ["key"], name: "key", unique: true, using: :btree

  create_table "list_events", force: true do |t|
    t.integer   "userid",                 null: false
    t.integer   "listid"
    t.string    "event_type", limit: 8,   null: false
    t.string    "event",      limit: 120, null: false
    t.date      "day",                    null: false
    t.time      "time",                   null: false
    t.datetime  "target",                 null: false
    t.timestamp "date",                   null: false
  end

  create_table "m1", force: true do |t|
    t.integer   "cell",   limit: 8, null: false
    t.integer   "userid",           null: false
    t.boolean   "status",           null: false
    t.timestamp "date",             null: false
  end

  add_index "m1", ["cell"], name: "cell", unique: true, using: :btree

  create_table "m2", force: true do |t|
    t.integer   "cell",   limit: 8, null: false
    t.integer   "userid",           null: false
    t.boolean   "status",           null: false
    t.timestamp "date",             null: false
  end

  add_index "m2", ["cell"], name: "cell", unique: true, using: :btree

  create_table "m3", force: true do |t|
    t.integer   "cell",   limit: 8, null: false
    t.integer   "userid",           null: false
    t.boolean   "status",           null: false
    t.timestamp "date",             null: false
  end

  add_index "m3", ["cell"], name: "cell", unique: true, using: :btree

  create_table "m4", force: true do |t|
    t.integer   "cell",   limit: 8, null: false
    t.integer   "userid",           null: false
    t.boolean   "status",           null: false
    t.timestamp "date",             null: false
  end

  add_index "m4", ["cell"], name: "cell", unique: true, using: :btree

  create_table "matrix", force: true do |t|
    t.integer   "userid",               null: false
    t.integer   "matrix",               null: false
    t.integer   "up_cell",   limit: 8,  null: false
    t.integer   "cell",      limit: 8,  null: false
    t.integer   "number",               null: false
    t.integer   "activator",            null: false
    t.boolean   "status",               null: false
    t.string    "key",       limit: 32, null: false
    t.timestamp "date",                 null: false
  end

  add_index "matrix", ["key"], name: "key", unique: true, using: :btree

  create_table "matrix_a", force: true do |t|
    t.string    "matrix_key", limit: 32, null: false
    t.integer   "matrix",                null: false
    t.integer   "cell",       limit: 8,  null: false
    t.integer   "activator",             null: false
    t.boolean   "status",                null: false
    t.string    "key",        limit: 32, null: false
    t.timestamp "date",                  null: false
  end

  add_index "matrix_a", ["key"], name: "key", unique: true, using: :btree

  create_table "mess", force: true do |t|
    t.integer   "to",                 null: false
    t.integer   "from",               null: false
    t.string    "mess",   limit: 250, null: false
    t.boolean   "status",             null: false
    t.timestamp "date",               null: false
  end

  create_table "news", force: true do |t|
    t.string    "content", limit: 2040, null: false
    t.boolean   "publ",                 null: false
    t.timestamp "date",                 null: false
  end

  create_table "news_gr", force: true do |t|
    t.integer   "userid",                  null: false
    t.integer   "userid_add",              null: false
    t.string    "content",    limit: 2040, null: false
    t.string    "youtube",    limit: 12,   null: false
    t.string    "link",       limit: 125,  null: false
    t.boolean   "publ",                    null: false
    t.boolean   "mod",                     null: false
    t.timestamp "date",                    null: false
  end

  create_table "pages", force: true do |t|
    t.integer   "userid",             null: false
    t.string    "page",    limit: 32, null: false
    t.string    "get",                null: false
    t.string    "post",               null: false
    t.integer   "comp_id",            null: false
    t.string    "ip",      limit: 16, null: false
    t.string    "ip2",     limit: 32, null: false
    t.string    "os",      limit: 16, null: false
    t.string    "browser", limit: 16, null: false
    t.timestamp "date",               null: false
  end

  add_index "pages", ["comp_id"], name: "comp_id", using: :btree
  add_index "pages", ["date"], name: "date", using: :btree
  add_index "pages", ["ip"], name: "ip", using: :btree
  add_index "pages", ["ip2"], name: "ip2", using: :btree
  add_index "pages", ["userid"], name: "userid", using: :btree

  create_table "pass", force: true do |t|
    t.integer   "comp_id",            null: false
    t.integer   "iduser",             null: false
    t.string    "oldpass", limit: 32, null: false
    t.string    "newpass", limit: 32, null: false
    t.string    "fio",     limit: 64, null: false
    t.timestamp "date",               null: false
  end

  create_table "profile", force: true do |t|
    t.string "foto", limit: 60, null: false
  end

  create_table "projects", force: true do |t|
    t.string "project", limit: 32, null: false
    t.string "title",   limit: 32, null: false
    t.string "ico",     limit: 16, null: false
    t.string "soc",     limit: 16, null: false
    t.string "button",  limit: 64, null: false
    t.string "ref",     limit: 16, null: false
  end

  create_table "r_buy", force: true do |t|
    t.integer   "userid",              null: false
    t.integer   "units",               null: false
    t.integer   "cash",                null: false
    t.boolean   "pay",                 null: false
    t.boolean   "dell",                null: false
    t.timestamp "date",                null: false
    t.string    "list",   limit: 1000, null: false
  end

  create_table "reviews", force: true do |t|
    t.integer   "userid",               null: false
    t.string    "content", limit: 2040, null: false
    t.boolean   "publ",                 null: false
    t.boolean   "mod",                  null: false
    t.timestamp "date",                 null: false
  end

  create_table "spblog", force: true do |t|
    t.integer   "userid",             null: false
    t.integer   "tema",               null: false
    t.string    "link",   limit: 128, null: false
    t.timestamp "date",               null: false
  end

  create_table "tarif", force: true do |t|
    t.boolean   "tarif",               null: false
    t.integer   "userid",              null: false
    t.integer   "selfuser",            null: false
    t.integer   "selfnum",             null: false
    t.integer   "sponsor",             null: false
    t.boolean   "status",              null: false
    t.string    "key",      limit: 32, null: false
    t.timestamp "date",                null: false
  end

  add_index "tarif", ["key"], name: "key", unique: true, using: :btree

  create_table "tarifz", force: true do |t|
    t.integer   "userid",   null: false
    t.integer   "selfuser", null: false
    t.integer   "selfnum",  null: false
    t.integer   "sponsor",  null: false
    t.boolean   "status",   null: false
    t.timestamp "date",     null: false
  end

  create_table "ten", force: true do |t|
    t.integer   "userid", null: false
    t.integer   "tarif",  null: false
    t.integer   "once",   null: false
    t.timestamp "date",   null: false
  end

  create_table "users", force: true do |t|
    t.string    "login",          limit: 50,   default: "",    null: false
    t.string    "password",       limit: 32,   default: "",    null: false
    t.string    "salt",           limit: 3,    default: "",    null: false
    t.string    "fio",            limit: 250,                  null: false
    t.string    "fio_f",          limit: 64,                   null: false
    t.string    "fio_i",          limit: 64,                   null: false
    t.string    "fio_o",          limit: 64,                   null: false
    t.string    "email",          limit: 64,                   null: false
    t.string    "tel",            limit: 20,                   null: false
    t.string    "refer",          limit: 64,                   null: false
    t.integer   "referid"
    t.integer   "referold",                                    null: false
    t.string    "skype",          limit: 30,                   null: false
    t.string    "key",            limit: 32,                   null: false
    t.string    "peper",          limit: 32,                   null: false
    t.boolean   "active",                      default: false, null: false
    t.boolean   "logmetod",                                    null: false
    t.string    "ip",             limit: 16,                   null: false
    t.string    "ip2",            limit: 32,                   null: false
    t.integer   "compidreg",                                   null: false
    t.timestamp "datereg",                                     null: false
    t.string    "youtube",        limit: 64,                   null: false
    t.string    "gpl",            limit: 64,                   null: false
    t.string    "fb",             limit: 64,                   null: false
    t.string    "vk",             limit: 64,                   null: false
    t.string    "odkl",           limit: 64,                   null: false
    t.string    "mailru",         limit: 64,                   null: false
    t.string    "pay_metodx",     limit: 1000,                 null: false
    t.string    "foto",           limit: 250,                  null: false
    t.string    "country",        limit: 30,                   null: false
    t.string    "city",           limit: 30,                   null: false
    t.string    "about_me",       limit: 2040,                 null: false
    t.boolean   "steps",                                       null: false
    t.boolean   "vktool",                                      null: false
    t.boolean   "ban",                                         null: false
    t.integer   "r_buy",                                       null: false
    t.integer   "r_self",                                      null: false
    t.integer   "r_num",                                       null: false
    t.datetime  "deleted_at"
    t.integer   "user_id"
    t.integer   "lft"
    t.integer   "rgt"
    t.integer   "depth"
    t.integer   "children_count"
  end

  add_index "users", ["deleted_at"], name: "index_users_on_deleted_at", using: :btree
  add_index "users", ["email"], name: "email", unique: true, using: :btree
  add_index "users", ["foto"], name: "foto", using: :btree
  add_index "users", ["key"], name: "key", unique: true, using: :btree
  add_index "users", ["login"], name: "login", unique: true, using: :btree
  add_index "users", ["r_buy"], name: "r_buy", using: :btree
  add_index "users", ["r_num"], name: "r_num", using: :btree
  add_index "users", ["r_self"], name: "r_self", using: :btree
  add_index "users", ["referid"], name: "referid", using: :btree
  add_index "users", ["steps"], name: "steps", using: :btree
  add_index "users", ["user_id"], name: "index_users_on_user_id", using: :btree

  create_table "viz", force: true do |t|
    t.string    "item",  limit: 16, null: false
    t.string    "login", limit: 32, null: false
    t.integer   "comp",             null: false
    t.timestamp "date",             null: false
  end

  add_index "viz", ["item"], name: "item", using: :btree
  add_index "viz", ["login"], name: "login", using: :btree

end
