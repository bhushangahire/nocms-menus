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

ActiveRecord::Schema.define(version: 20141002111539) do

  create_table "no_cms_menus_menu_item_translations", force: true do |t|
    t.integer  "no_cms_menus_menu_item_id"
    t.string   "locale"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "external_url"
    t.boolean  "draft",                     default: false
    t.boolean  "leaf_with_draft",           default: false
  end

  add_index "no_cms_menus_menu_item_translations", ["leaf_with_draft"], name: "index_no_cms_menus_menu_item_translations_on_leaf_with_draft"
  add_index "no_cms_menus_menu_item_translations", ["no_cms_menus_menu_item_id"], name: "no_cms_menu_item_on_translations"

  create_table "no_cms_menus_menu_items", force: true do |t|
    t.integer  "menu_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.integer  "menuable_id"
    t.string   "menuable_type"
    t.string   "menu_action"
    t.string   "kind"
    t.integer  "position"
    t.string   "css_class"
    t.boolean  "turbolinks"
    t.string   "rel"
  end

  add_index "no_cms_menus_menu_items", ["menu_id"], name: "index_no_cms_menus_menu_items_on_menu_id"
  add_index "no_cms_menus_menu_items", ["menuable_id", "menuable_type"], name: "index_no_cms_menus_menu_items_on_menuable_id_and_menuable_type"

  create_table "no_cms_menus_menu_translations", force: true do |t|
    t.integer  "no_cms_menus_menu_id"
    t.string   "locale"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "no_cms_menus_menu_translations", ["no_cms_menus_menu_id"], name: "index_no_cms_menus_menu_translations_on_no_cms_menus_menu_id"

  create_table "no_cms_menus_menus", force: true do |t|
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
