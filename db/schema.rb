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

ActiveRecord::Schema.define(version: 20150617070955) do

  create_table "books", force: :cascade do |t|
    t.integer  "cat_id",         limit: 4
    t.string   "author_name",    limit: 255
    t.string   "name",           limit: 255
    t.string   "original_url",   limit: 255
    t.boolean  "current_status", limit: 1
    t.text     "description",    limit: 65535
    t.string   "icon_url",       limit: 255
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "books", ["author_name"], name: "index_books_on_author_name", using: :btree
  add_index "books", ["cat_id"], name: "index_books_on_cat_id", using: :btree
  add_index "books", ["name"], name: "index_books_on_name", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "books",      limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "cats", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "chapters", force: :cascade do |t|
    t.integer  "book_id",    limit: 4
    t.string   "name",       limit: 255
    t.text     "content",    limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "seq",        limit: 4
  end

  add_index "chapters", ["book_id", "seq"], name: "index_chapters_on_book_id_and_seq", using: :btree

end
