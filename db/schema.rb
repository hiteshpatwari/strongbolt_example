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

ActiveRecord::Schema.define(version: 20160212175248) do

  create_table "articles", force: :cascade do |t|
    t.string   "title"
    t.text     "text"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "category_id"
  end

  add_index "articles", ["category_id"], name: "index_articles_on_category_id"

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.string   "commenter"
    t.text     "body"
    t.integer  "article_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "comments", ["article_id"], name: "index_comments_on_article_id"

  create_table "strongbolt_capabilities", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "model"
    t.string   "action"
    t.string   "attr"
    t.boolean  "require_ownership",     default: false, null: false
    t.boolean  "require_tenant_access", default: true,  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "strongbolt_capabilities_roles", force: :cascade do |t|
    t.integer "role_id"
    t.integer "capability_id"
  end

  add_index "strongbolt_capabilities_roles", ["capability_id"], name: "index_strongbolt_capabilities_roles_on_capability_id"
  add_index "strongbolt_capabilities_roles", ["role_id"], name: "index_strongbolt_capabilities_roles_on_role_id"

  create_table "strongbolt_roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "strongbolt_roles", ["lft"], name: "index_strongbolt_roles_on_lft"
  add_index "strongbolt_roles", ["parent_id"], name: "index_strongbolt_roles_on_parent_id"
  add_index "strongbolt_roles", ["rgt"], name: "index_strongbolt_roles_on_rgt"

  create_table "strongbolt_roles_user_groups", force: :cascade do |t|
    t.integer "user_group_id"
    t.integer "role_id"
  end

  add_index "strongbolt_roles_user_groups", ["role_id"], name: "index_strongbolt_roles_user_groups_on_role_id"
  add_index "strongbolt_roles_user_groups", ["user_group_id"], name: "index_strongbolt_roles_user_groups_on_user_group_id"

  create_table "strongbolt_user_groups", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "strongbolt_user_groups_users", force: :cascade do |t|
    t.integer "user_group_id"
    t.integer "user_id"
  end

  add_index "strongbolt_user_groups_users", ["user_group_id"], name: "index_strongbolt_user_groups_users_on_user_group_id"
  add_index "strongbolt_user_groups_users", ["user_id"], name: "index_strongbolt_user_groups_users_on_user_id"

  create_table "strongbolt_users_tenants", force: :cascade do |t|
    t.integer "user_id"
    t.integer "tenant_id"
    t.string  "type"
  end

  add_index "strongbolt_users_tenants", ["tenant_id", "type"], name: "index_strongbolt_users_tenants_on_tenant_id_and_type"
  add_index "strongbolt_users_tenants", ["tenant_id"], name: "index_strongbolt_users_tenants_on_tenant_id"
  add_index "strongbolt_users_tenants", ["type"], name: "index_strongbolt_users_tenants_on_type"
  add_index "strongbolt_users_tenants", ["user_id"], name: "index_strongbolt_users_tenants_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
