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

ActiveRecord::Schema.define(version: 20161222144006) do

  create_table "activation_requests", force: :cascade do |t|
    t.integer  "user_id",             limit: 4
    t.integer  "admin_id",            limit: 4
    t.integer  "system_deposit_id",   limit: 4
    t.integer  "parent_deposit_id",   limit: 4
    t.string   "state",               limit: 255,   default: "pending"
    t.string   "system_invoice_file", limit: 255
    t.string   "parent_invoice_file", limit: 255
    t.boolean  "system",                            default: true
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.string   "pay_system",          limit: 255,   default: "advcash"
    t.text     "comment",             limit: 65535
  end

  add_index "activation_requests", ["admin_id"], name: "index_activation_requests_on_admin_id", using: :btree
  add_index "activation_requests", ["parent_deposit_id"], name: "index_activation_requests_on_parent_deposit_id", using: :btree
  add_index "activation_requests", ["system_deposit_id"], name: "index_activation_requests_on_system_deposit_id", using: :btree
  add_index "activation_requests", ["user_id"], name: "index_activation_requests_on_user_id", using: :btree

  create_table "activities", force: :cascade do |t|
    t.integer  "trackable_id",   limit: 4
    t.string   "trackable_type", limit: 255
    t.integer  "owner_id",       limit: 4
    t.string   "owner_type",     limit: 255
    t.string   "key",            limit: 255
    t.text     "parameters",     limit: 65535
    t.integer  "recipient_id",   limit: 4
    t.string   "recipient_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree

  create_table "authentications", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.string   "provider",   limit: 255
    t.string   "uid",        limit: 255
    t.string   "token",      limit: 255
    t.datetime "expires_at"
    t.string   "url",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authentications", ["provider", "uid"], name: "index_authentications_on_provider_and_uid", using: :btree
  add_index "authentications", ["provider"], name: "index_authentications_on_provider", using: :btree
  add_index "authentications", ["token"], name: "index_authentications_on_token", using: :btree
  add_index "authentications", ["uid"], name: "index_authentications_on_uid", using: :btree
  add_index "authentications", ["user_id"], name: "index_authentications_on_user_id", using: :btree

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",    limit: 255, null: false
    t.string   "data_content_type", limit: 255
    t.integer  "data_file_size",    limit: 4
    t.integer  "assetable_id",      limit: 4
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width",             limit: 4
    t.integer  "height",            limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "companies", force: :cascade do |t|
    t.integer  "user_id",     limit: 4
    t.string   "name",        limit: 255
    t.string   "logo",        limit: 255
    t.text     "description", limit: 65535
    t.string   "video_url",   limit: 255
    t.text     "marketing",   limit: 65535
    t.decimal  "rating",                    precision: 4, scale: 2, default: 0.0
    t.boolean  "moderated",                                         default: false
    t.datetime "created_at",                                                        null: false
    t.datetime "updated_at",                                                        null: false
  end

  add_index "companies", ["user_id"], name: "index_companies_on_user_id", using: :btree

  create_table "company_votes", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "company_id", limit: 4
    t.decimal  "vote",                 precision: 4, scale: 2, default: 0.0
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
  end

  add_index "company_votes", ["company_id"], name: "index_company_votes_on_company_id", using: :btree
  add_index "company_votes", ["user_id"], name: "index_company_votes_on_user_id", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   limit: 4,     default: 0, null: false
    t.integer  "attempts",   limit: 4,     default: 0, null: false
    t.text     "handler",    limit: 65535,             null: false
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "documents", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file",       limit: 255
  end

  add_index "documents", ["user_id"], name: "index_documents_on_user_id", using: :btree

  create_table "informes", force: :cascade do |t|
    t.string   "email",      limit: 255
    t.string   "token",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "landing_contacts", force: :cascade do |t|
    t.integer  "partner_id", limit: 4
    t.string   "name",       limit: 255
    t.string   "email",      limit: 255
    t.string   "phone",      limit: 255
    t.string   "address",    limit: 255
    t.string   "ip_address", limit: 255
    t.boolean  "read",                     default: false
    t.text     "message",    limit: 65535
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "landing_contacts", ["partner_id"], name: "index_landing_contacts_on_partner_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.string   "message_type", limit: 255
    t.string   "subject",      limit: 255
    t.text     "body",         limit: 65535
    t.boolean  "is_active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",      limit: 4
  end

  create_table "payments", force: :cascade do |t|
    t.string   "type",         limit: 255
    t.integer  "user_id",      limit: 4
    t.integer  "amount_cents", limit: 4,     default: 0,         null: false
    t.string   "currency",     limit: 255,   default: "USD"
    t.string   "token",        limit: 255
    t.string   "identifier",   limit: 255
    t.string   "payer_id",     limit: 255
    t.string   "state",        limit: 255,   default: "pending"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "invoice_file", limit: 255
    t.text     "comment",      limit: 65535
  end

  add_index "payments", ["currency"], name: "index_payments_on_currency", using: :btree
  add_index "payments", ["identifier"], name: "index_payments_on_identifier", using: :btree
  add_index "payments", ["state"], name: "index_payments_on_state", using: :btree
  add_index "payments", ["token"], name: "index_payments_on_token", using: :btree
  add_index "payments", ["type"], name: "index_payments_on_type", using: :btree
  add_index "payments", ["user_id"], name: "index_payments_on_user_id", using: :btree

  create_table "purse_payments", force: :cascade do |t|
    t.string   "type",              limit: 255
    t.integer  "source_purse_id",   limit: 4
    t.integer  "purse_id",          limit: 4
    t.integer  "source_payment_id", limit: 4
    t.integer  "target_id",         limit: 4
    t.string   "target_type",       limit: 255
    t.string   "name",              limit: 255
    t.text     "description",       limit: 65535
    t.integer  "amount_cents",      limit: 4,     default: 0,         null: false
    t.string   "state",             limit: 255,   default: "pending"
    t.text     "params",            limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "purse_payments", ["purse_id"], name: "index_purse_payments_on_purse_id", using: :btree
  add_index "purse_payments", ["source_payment_id"], name: "index_purse_payments_on_source_payment_id", using: :btree
  add_index "purse_payments", ["source_purse_id"], name: "index_purse_payments_on_source_purse_id", using: :btree
  add_index "purse_payments", ["state"], name: "index_purse_payments_on_state", using: :btree
  add_index "purse_payments", ["target_type", "target_id"], name: "index_purse_payments_on_target_type_and_target_id", using: :btree
  add_index "purse_payments", ["type"], name: "index_purse_payments_on_type", using: :btree

  create_table "purses", force: :cascade do |t|
    t.integer  "amount_cents", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer  "author_id",  limit: 4
    t.boolean  "moderated",                default: false
    t.text     "body",       limit: 65535
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "reviews", ["author_id"], name: "index_reviews_on_author_id", using: :btree

  create_table "system_accounts", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "identifier", limit: 255
    t.integer  "purse_id",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "system_accounts", ["purse_id"], name: "index_system_accounts_on_purse_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                   limit: 255,   default: "",        null: false
    t.string   "encrypted_password",      limit: 255,   default: ""
    t.string   "reset_password_token",    limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",           limit: 4,     default: 0,         null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",      limit: 255
    t.string   "last_sign_in_ip",         limit: 255
    t.string   "confirmation_token",      limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "invitation_token",        limit: 255
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit",        limit: 4
    t.integer  "invited_by_id",           limit: 4
    t.string   "invited_by_type",         limit: 255
    t.integer  "invitations_count",       limit: 4,     default: 0
    t.string   "phone",                   limit: 255
    t.integer  "parent_id",               limit: 4
    t.integer  "lft",                     limit: 4
    t.integer  "rgt",                     limit: 4
    t.integer  "children_count",          limit: 4
    t.string   "token",                   limit: 255
    t.integer  "purse_id",                limit: 4
    t.string   "role",                    limit: 255,   default: "user",    null: false
    t.string   "avatar",                  limit: 255
    t.string   "first_name",              limit: 255
    t.string   "last_name",               limit: 255
    t.string   "middle_name",             limit: 255
    t.string   "skype",                   limit: 255
    t.text     "address",                 limit: 65535
    t.string   "username",                limit: 255
    t.string   "state",                   limit: 255,   default: "pending"
    t.text     "avatar_meta",             limit: 65535
    t.integer  "plan",                    limit: 4,     default: 1
    t.integer  "activation_count",        limit: 4,     default: 0
    t.integer  "free_points",             limit: 4
    t.integer  "credit_activation_limit", limit: 4,     default: 0
    t.text     "about_me",                limit: 65535
    t.text     "success_story",           limit: 65535
    t.string   "lending_type",            limit: 255,   default: "one"
  end

  add_index "users", ["activation_count"], name: "index_users_on_activation_count", using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["free_points"], name: "index_users_on_free_points", using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["lending_type"], name: "index_users_on_lending_type", using: :btree
  add_index "users", ["parent_id"], name: "index_users_on_parent_id", using: :btree
  add_index "users", ["phone"], name: "index_users_on_phone", unique: true, using: :btree
  add_index "users", ["purse_id"], name: "index_users_on_purse_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["state"], name: "index_users_on_state", using: :btree
  add_index "users", ["token"], name: "index_users_on_token", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", using: :btree

  create_table "voucher_requests", force: :cascade do |t|
    t.integer  "owner_id",     limit: 4
    t.integer  "user_id",      limit: 4
    t.integer  "voucher_id",   limit: 4
    t.string   "state",        limit: 255, default: "pending"
    t.datetime "activated_at"
    t.datetime "completed_at"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
  end

  add_index "voucher_requests", ["owner_id"], name: "index_voucher_requests_on_owner_id", using: :btree
  add_index "voucher_requests", ["user_id"], name: "index_voucher_requests_on_user_id", using: :btree
  add_index "voucher_requests", ["voucher_id"], name: "index_voucher_requests_on_voucher_id", using: :btree

  create_table "vouchers", force: :cascade do |t|
    t.string   "type",         limit: 255
    t.integer  "owner_id",     limit: 4
    t.integer  "user_id",      limit: 4
    t.integer  "amount_cents", limit: 4
    t.string   "state",        limit: 255, default: "pending"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vouchers", ["owner_id"], name: "index_vouchers_on_owner_id", using: :btree
  add_index "vouchers", ["state"], name: "index_vouchers_on_state", using: :btree
  add_index "vouchers", ["type"], name: "index_vouchers_on_type", using: :btree
  add_index "vouchers", ["user_id"], name: "index_vouchers_on_user_id", using: :btree

  add_foreign_key "activation_requests", "users"
  add_foreign_key "companies", "users"
  add_foreign_key "company_votes", "companies"
  add_foreign_key "company_votes", "users"
  add_foreign_key "voucher_requests", "users"
  add_foreign_key "voucher_requests", "vouchers"
end
