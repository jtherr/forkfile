# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090623224233) do

  create_table "bill_orders", :force => true do |t|
    t.integer "bill_id",  :null => false
    t.integer "order_id", :null => false
  end

  add_index "bill_orders", ["bill_id"], :name => "FK_bill_id1"
  add_index "bill_orders", ["order_id"], :name => "FK_order_id3"

  create_table "bills", :force => true do |t|
    t.integer  "restaurant_id",                                                                 :null => false
    t.datetime "bill_start_date",                                                               :null => false
    t.datetime "bill_end_date",                                                                 :null => false
    t.decimal  "bill_amount",                     :precision => 8, :scale => 2,                 :null => false
    t.datetime "notification_date"
    t.datetime "charge_date"
    t.string   "status",            :limit => 45,                               :default => "", :null => false
  end

  add_index "bills", ["restaurant_id"], :name => "FK_restaurant_id8"

  create_table "categories", :force => true do |t|
    t.string  "name",          :limit => 45,  :default => "", :null => false
    t.integer "restaurant_id",                :default => 0,  :null => false
    t.integer "position",                     :default => 0,  :null => false
    t.string  "description",   :limit => 500
  end

  add_index "categories", ["restaurant_id"], :name => "FK_categories_1"

  create_table "category_hours", :force => true do |t|
    t.string  "start_hour",   :limit => 2, :default => "", :null => false
    t.string  "end_hour",     :limit => 2, :default => "", :null => false
    t.string  "start_minute", :limit => 2, :default => "", :null => false
    t.string  "end_minute",   :limit => 2, :default => "", :null => false
    t.integer "category_id",                               :null => false
    t.boolean "sunday",                                    :null => false
    t.boolean "monday",                                    :null => false
    t.boolean "tuesday",                                   :null => false
    t.boolean "wednesday",                                 :null => false
    t.boolean "thursday",                                  :null => false
    t.boolean "friday",                                    :null => false
    t.boolean "saturday",                                  :null => false
  end

  create_table "credit_card_types", :force => true do |t|
    t.string "name", :limit => 45, :default => "", :null => false
    t.string "code", :limit => 45, :default => "", :null => false
  end

  create_table "cuisines", :force => true do |t|
    t.string "name", :limit => 45, :default => "", :null => false
  end

  create_table "delivery_hours", :force => true do |t|
    t.string  "start_hour",    :default => "", :null => false
    t.string  "end_hour",      :default => "", :null => false
    t.integer "restaurant_id",                 :null => false
    t.string  "start_minute",  :default => "", :null => false
    t.string  "end_minute",    :default => "", :null => false
    t.boolean "sunday",                        :null => false
    t.boolean "monday",                        :null => false
    t.boolean "tuesday",                       :null => false
    t.boolean "wednesday",                     :null => false
    t.boolean "thursday",                      :null => false
    t.boolean "friday",                        :null => false
    t.boolean "saturday",                      :null => false
  end

  create_table "delivery_zip_codes", :force => true do |t|
    t.string  "zip",           :limit => 20, :default => "", :null => false
    t.integer "restaurant_id",                               :null => false
  end

  add_index "delivery_zip_codes", ["restaurant_id"], :name => "FK_restaurant_id4"

  create_table "discount_group_parts", :force => true do |t|
    t.integer "discount_group_id",     :null => false
    t.integer "category_id"
    t.integer "item_id"
    t.integer "item_size_name_id"
    t.integer "option_group_id"
    t.integer "option_group_quantity"
  end

  create_table "discount_groups", :force => true do |t|
    t.string  "name",          :default => "", :null => false
    t.integer "restaurant_id",                 :null => false
  end

  create_table "discount_hours", :force => true do |t|
    t.integer "discount_id",                  :null => false
    t.string  "start_hour",   :default => "", :null => false
    t.string  "end_hour",     :default => "", :null => false
    t.string  "start_minute", :default => "", :null => false
    t.string  "end_minute",   :default => "", :null => false
    t.boolean "sunday",                       :null => false
    t.boolean "monday",                       :null => false
    t.boolean "tuesday",                      :null => false
    t.boolean "wednesday",                    :null => false
    t.boolean "thursday",                     :null => false
    t.boolean "friday",                       :null => false
    t.boolean "saturday",                     :null => false
  end

  create_table "discounts", :force => true do |t|
    t.string  "name",                                                :default => "", :null => false
    t.string  "description"
    t.integer "buy_quantity"
    t.decimal "buy_amount",            :precision => 8, :scale => 2
    t.integer "buy_discount_group_id"
    t.integer "get_quantity"
    t.decimal "get_percent_off",       :precision => 8, :scale => 2
    t.decimal "get_amount_off",        :precision => 8, :scale => 2
    t.integer "get_discount_group_id"
    t.boolean "allow_combo",                                                         :null => false
    t.boolean "delivery",                                                            :null => false
    t.boolean "take_out",                                                            :null => false
    t.integer "priority",                                                            :null => false
    t.integer "restaurant_id",                                                       :null => false
    t.decimal "get_for_amount",        :precision => 8, :scale => 2
    t.boolean "get_match_all_parts"
    t.boolean "buy_match_all_parts"
  end

  create_table "favorites", :force => true do |t|
    t.integer "restaurant_id", :null => false
    t.integer "user_id",       :null => false
  end

  add_index "favorites", ["restaurant_id"], :name => "FK_restaurant_id6"
  add_index "favorites", ["user_id"], :name => "FK_user_id2"

  create_table "item_discount_groups", :force => true do |t|
    t.integer "group_count",                                                                    :null => false
    t.string  "discount_type",     :limit => 45,                                :default => "", :null => false
    t.integer "discount_amount",   :limit => 10, :precision => 10, :scale => 0,                 :null => false
    t.integer "discount_quantity", :limit => 10, :precision => 10, :scale => 0,                 :null => false
  end

  create_table "item_option_groups", :force => true do |t|
    t.integer "item_id",         :null => false
    t.integer "option_group_id", :null => false
  end

  add_index "item_option_groups", ["item_id"], :name => "FK_item_option_groups_1"
  add_index "item_option_groups", ["option_group_id"], :name => "FK_item_option_groups_2"

  create_table "item_size_name_hours", :force => true do |t|
    t.string  "start_hour",        :limit => 2, :default => "", :null => false
    t.string  "start_minute",      :limit => 2, :default => "", :null => false
    t.string  "end_hour",          :limit => 2, :default => "", :null => false
    t.string  "end_minute",        :limit => 2, :default => "", :null => false
    t.integer "item_size_name_id",                              :null => false
    t.boolean "sunday",                                         :null => false
    t.boolean "monday",                                         :null => false
    t.boolean "tuesday",                                        :null => false
    t.boolean "wednesday",                                      :null => false
    t.boolean "thursday",                                       :null => false
    t.boolean "friday",                                         :null => false
    t.boolean "saturday",                                       :null => false
  end

  add_index "item_size_name_hours", ["item_size_name_id"], :name => "FK_item_size_hours_1"

  create_table "item_size_names", :force => true do |t|
    t.string  "name",          :limit => 45, :default => "", :null => false
    t.integer "restaurant_id",                               :null => false
  end

  add_index "item_size_names", ["restaurant_id"], :name => "FK_item_size_names_1"

  create_table "item_size_versions", :force => true do |t|
    t.integer  "item_size_id"
    t.integer  "version"
    t.integer  "item_id"
    t.decimal  "price",             :precision => 8, :scale => 2
    t.datetime "updated_at"
    t.integer  "status_id",                                       :default => 1, :null => false
    t.integer  "item_size_name_id",                                              :null => false
    t.boolean  "special_only",                                                   :null => false
  end

  create_table "item_sizes", :force => true do |t|
    t.integer "item_id",                                                        :null => false
    t.decimal "price",             :precision => 8, :scale => 2
    t.integer "version"
    t.integer "status_id",                                       :default => 1, :null => false
    t.integer "item_size_name_id",                                              :null => false
    t.boolean "special_only",                                                   :null => false
  end

  add_index "item_sizes", ["item_id"], :name => "FK_item_id2"
  add_index "item_sizes", ["item_size_name_id"], :name => "FK_item_sizes_3"
  add_index "item_sizes", ["status_id"], :name => "FK_item_sizes_2"

  create_table "item_versions", :force => true do |t|
    t.integer  "item_id"
    t.integer  "version"
    t.integer  "restaurant_id"
    t.string   "name",                   :limit => 100, :default => ""
    t.string   "description",            :limit => 500
    t.integer  "category_id"
    t.integer  "item_discount_group_id"
    t.datetime "updated_at"
    t.integer  "status_id",                             :default => 1,  :null => false
    t.integer  "position",                              :default => 0,  :null => false
    t.boolean  "spicy",                                                 :null => false
    t.boolean  "vegetarian",                                            :null => false
    t.boolean  "featured",                                              :null => false
  end

  create_table "items", :force => true do |t|
    t.integer "restaurant_id",                                         :null => false
    t.string  "name",                   :limit => 100, :default => "", :null => false
    t.string  "description",            :limit => 500
    t.integer "category_id",                                           :null => false
    t.integer "item_discount_group_id"
    t.integer "version"
    t.integer "status_id",                             :default => 1,  :null => false
    t.integer "position",                              :default => 0,  :null => false
    t.boolean "spicy",                                                 :null => false
    t.boolean "vegetarian",                                            :null => false
    t.boolean "featured",                                              :null => false
  end

  add_index "items", ["category_id"], :name => "FK_category_id1"
  add_index "items", ["item_discount_group_id"], :name => "FK_item_discount_group_id1"
  add_index "items", ["restaurant_id"], :name => "FK_restaurant_id3"
  add_index "items", ["status_id"], :name => "FK_items_4"

  create_table "locality_taxes", :force => true do |t|
    t.string  "city_name"
    t.string  "county_name"
    t.decimal "meal_tax",    :precision => 8, :scale => 2
    t.integer "state_id",                                  :null => false
  end

  create_table "logos", :force => true do |t|
    t.integer "restaurant_id",                                :null => false
    t.string  "content_type",  :limit => 45,  :default => "", :null => false
    t.string  "filename",      :limit => 200, :default => "", :null => false
  end

  add_index "logos", ["restaurant_id"], :name => "FK_logos_1"

  create_table "notification_notes", :force => true do |t|
    t.integer  "user_id",                                        :null => false
    t.string   "notes",           :limit => 500, :default => "", :null => false
    t.datetime "date",                                           :null => false
    t.integer  "notification_id",                                :null => false
  end

  add_index "notification_notes", ["notification_id"], :name => "FK_notification_notes_2"
  add_index "notification_notes", ["user_id"], :name => "FK_notification_notes_1"

  create_table "notification_reasons", :force => true do |t|
    t.string "name", :limit => 100, :default => "", :null => false
  end

  create_table "notifications", :force => true do |t|
    t.integer  "user_id"
    t.string   "order_number"
    t.string   "email",                  :limit => 100
    t.integer  "notification_reason_id",                                   :null => false
    t.string   "message",                :limit => 500, :default => "",    :null => false
    t.boolean  "viewed",                                :default => false, :null => false
    t.datetime "date",                                                     :null => false
    t.integer  "status",                                :default => 0,     :null => false
    t.string   "name"
    t.string   "phone"
    t.string   "restaurant_name"
    t.string   "street1"
    t.string   "street2"
    t.string   "city"
    t.integer  "state_id"
    t.string   "zip"
  end

  add_index "notifications", ["notification_reason_id"], :name => "FK_notifications_3"
  add_index "notifications", ["order_number"], :name => "FK_order_id10"
  add_index "notifications", ["user_id"], :name => "FK_user_id5"

  create_table "option_group_versions", :force => true do |t|
    t.integer  "option_group_id"
    t.integer  "version"
    t.string   "name",                    :limit => 50,                                :default => ""
    t.string   "description",             :limit => 100
    t.integer  "min_selected"
    t.integer  "max_selected"
    t.integer  "quantity_price_increase"
    t.decimal  "price_increase",                         :precision => 8, :scale => 2
    t.datetime "updated_at"
    t.integer  "status_id",                                                            :default => 1,  :null => false
    t.integer  "restaurant_id",                                                                        :null => false
  end

  create_table "option_groups", :force => true do |t|
    t.string  "name",                    :limit => 50,                                :default => "", :null => false
    t.string  "description",             :limit => 100
    t.integer "min_selected"
    t.integer "max_selected"
    t.integer "quantity_price_increase"
    t.decimal "price_increase",                         :precision => 8, :scale => 2
    t.integer "version"
    t.integer "status_id",                                                            :default => 1,  :null => false
    t.integer "restaurant_id",                                                                        :null => false
  end

  add_index "option_groups", ["restaurant_id"], :name => "FK_option_groups_3"
  add_index "option_groups", ["status_id"], :name => "FK_option_groups_2"

  create_table "option_size_versions", :force => true do |t|
    t.integer  "option_size_id"
    t.integer  "version"
    t.integer  "option_id"
    t.decimal  "additional_price",  :precision => 8, :scale => 2
    t.datetime "updated_at"
    t.integer  "status_id",                                       :default => 1, :null => false
    t.integer  "item_size_name_id",                                              :null => false
  end

  create_table "option_sizes", :force => true do |t|
    t.integer "option_id",                                                      :null => false
    t.decimal "additional_price",  :precision => 8, :scale => 2
    t.integer "version"
    t.integer "status_id",                                       :default => 1, :null => false
    t.integer "item_size_name_id",                                              :null => false
  end

  add_index "option_sizes", ["item_size_name_id"], :name => "FK_option_sizes_2"
  add_index "option_sizes", ["option_id"], :name => "FK_option_sizes_1"
  add_index "option_sizes", ["status_id"], :name => "FK_option_sizes_3"

  create_table "option_versions", :force => true do |t|
    t.integer  "option_id"
    t.integer  "version"
    t.integer  "option_group_id"
    t.string   "name",                :limit => 50,  :default => ""
    t.string   "description",         :limit => 100
    t.datetime "updated_at"
    t.integer  "status_id",                          :default => 1,  :null => false
    t.boolean  "selected_by_default",                                :null => false
    t.boolean  "allow_quantity",                                     :null => false
  end

  create_table "options", :force => true do |t|
    t.integer "option_group_id",                                    :null => false
    t.string  "name",                :limit => 50,  :default => "", :null => false
    t.string  "description",         :limit => 100
    t.integer "version"
    t.integer "status_id",                          :default => 1,  :null => false
    t.boolean "selected_by_default",                                :null => false
    t.boolean "allow_quantity",                                     :null => false
  end

  add_index "options", ["option_group_id"], :name => "FK_option_group_id1"
  add_index "options", ["status_id"], :name => "FK_options_2"

  create_table "order_item_options", :force => true do |t|
    t.integer "order_item_id", :null => false
    t.integer "option_id",     :null => false
    t.integer "quantity"
  end

  add_index "order_item_options", ["option_id"], :name => "FK_options_id1"
  add_index "order_item_options", ["order_item_id"], :name => "FK_order_item_id1"

  create_table "order_items", :force => true do |t|
    t.integer "item_size_id",                                                      :null => false
    t.integer "order_id",                                                          :null => false
    t.integer "quantity",                                           :default => 1, :null => false
    t.string  "special_instructions"
    t.decimal "price",                :precision => 8, :scale => 2,                :null => false
  end

  add_index "order_items", ["item_size_id"], :name => "FK_item_id5"
  add_index "order_items", ["order_id"], :name => "FK_order_id2"

  create_table "orders", :force => true do |t|
    t.integer  "restaurant_id",                                                                              :null => false
    t.integer  "user_id"
    t.decimal  "total_price",                                 :precision => 10, :scale => 2,                 :null => false
    t.datetime "order_time",                                                                                 :null => false
    t.string   "payment_type",                 :limit => 45,                                 :default => "", :null => false
    t.string   "credit_card_number",           :limit => 100
    t.integer  "credit_card_expiration_month"
    t.integer  "credit_card_expiration_year"
    t.integer  "credit_card_code"
    t.string   "order_type",                   :limit => 45,                                 :default => "", :null => false
    t.string   "delivery_street1",             :limit => 100
    t.string   "delivery_street2",             :limit => 100
    t.string   "delivery_city",                :limit => 100
    t.integer  "delivery_state_id"
    t.string   "delivery_zip",                 :limit => 20
    t.string   "status",                       :limit => 45,                                 :default => "", :null => false
    t.integer  "credit_card_type_id"
    t.string   "name",                         :limit => 100,                                :default => "", :null => false
    t.string   "credit_card_first_name",       :limit => 100
    t.string   "credit_card_last_name",        :limit => 100
    t.string   "phone",                        :limit => 45
    t.string   "order_number",                 :limit => 20,                                 :default => "", :null => false
    t.decimal  "sub_total",                                   :precision => 10, :scale => 2
    t.decimal  "delivery_charge",                             :precision => 10, :scale => 2
    t.decimal  "tax",                                         :precision => 10, :scale => 2
    t.boolean  "disclaimer_read",                                                                            :null => false
    t.decimal  "discount",                                    :precision => 8,  :scale => 2
    t.string   "email",                                                                      :default => "", :null => false
  end

  add_index "orders", ["credit_card_type_id"], :name => "FK_orders_4"
  add_index "orders", ["delivery_state_id"], :name => "FK_orders_3"
  add_index "orders", ["restaurant_id"], :name => "FK_restaurant_id7"
  add_index "orders", ["user_id"], :name => "FK_user_id4"

  create_table "refund_notes", :force => true do |t|
    t.integer  "refund_id",                                :null => false
    t.datetime "date",                                     :null => false
    t.string   "notes",     :limit => 500, :default => "", :null => false
    t.integer  "user_id",                                  :null => false
  end

  add_index "refund_notes", ["refund_id"], :name => "FK_refund_notes_1"
  add_index "refund_notes", ["user_id"], :name => "FK_refund_notes_2"

  create_table "refunds", :force => true do |t|
    t.decimal  "request_amount",                :precision => 10, :scale => 2,                    :null => false
    t.datetime "request_date",                                                                    :null => false
    t.string   "reason",         :limit => 200,                                :default => "",    :null => false
    t.integer  "order_id",                                                                        :null => false
    t.integer  "user_id"
    t.integer  "status",                                                                          :null => false
    t.datetime "grant_date"
    t.string   "email",          :limit => 100,                                :default => "",    :null => false
    t.boolean  "viewed",                                                       :default => false, :null => false
    t.integer  "restaurant_id",                                                                   :null => false
    t.decimal  "grant_amount",                  :precision => 10, :scale => 2
  end

  add_index "refunds", ["order_id"], :name => "FK_order_id5"
  add_index "refunds", ["restaurant_id"], :name => "FK_refunds_3"
  add_index "refunds", ["user_id"], :name => "FK_refunds_2"

  create_table "restaurant_credit_cards", :force => true do |t|
    t.integer "restaurant_id",       :null => false
    t.integer "credit_card_type_id", :null => false
  end

  add_index "restaurant_credit_cards", ["credit_card_type_id"], :name => "FK_restaurant_credit_cards_1"
  add_index "restaurant_credit_cards", ["restaurant_id"], :name => "FK_restaurant_credit_cards_2"

  create_table "restaurant_cuisines", :force => true do |t|
    t.integer "restaurant_id", :null => false
    t.integer "cuisine_id",    :null => false
  end

  add_index "restaurant_cuisines", ["cuisine_id"], :name => "FK_cuisine_id1"
  add_index "restaurant_cuisines", ["restaurant_id"], :name => "FK_restaurant_id2"

  create_table "restaurant_emails", :force => true do |t|
    t.integer "restaurant_id",                 :null => false
    t.string  "email",         :default => "", :null => false
  end

  create_table "restaurant_hour_exceptions", :force => true do |t|
    t.date    "from_date",      :null => false
    t.date    "to_date"
    t.integer "recurring_type", :null => false
    t.boolean "closed",         :null => false
    t.time    "from_time"
    t.time    "to_time"
    t.integer "restaurant_id",  :null => false
  end

  create_table "restaurant_hours", :force => true do |t|
    t.string  "start_hour",    :limit => 2, :default => "", :null => false
    t.string  "end_hour",      :limit => 2, :default => "", :null => false
    t.integer "restaurant_id",                              :null => false
    t.string  "start_minute",  :limit => 2, :default => "", :null => false
    t.string  "end_minute",    :limit => 2, :default => "", :null => false
    t.boolean "sunday",                                     :null => false
    t.boolean "monday",                                     :null => false
    t.boolean "tuesday",                                    :null => false
    t.boolean "wednesday",                                  :null => false
    t.boolean "thursday",                                   :null => false
    t.boolean "friday",                                     :null => false
    t.boolean "saturday",                                   :null => false
  end

  add_index "restaurant_hours", ["restaurant_id"], :name => "FK_restaurant_id"

  create_table "restaurant_owners", :force => true do |t|
    t.integer "restaurant_id", :null => false
    t.integer "user_id",       :null => false
  end

  add_index "restaurant_owners", ["restaurant_id"], :name => "FK_restaurant_id5"
  add_index "restaurant_owners", ["user_id"], :name => "FK_user_id1"

  create_table "restaurant_versions", :force => true do |t|
    t.integer  "restaurant_id"
    t.integer  "version"
    t.string   "name",                         :limit => 100,                                 :default => ""
    t.string   "street1",                      :limit => 100,                                 :default => ""
    t.string   "street2",                      :limit => 100
    t.string   "city",                         :limit => 45,                                  :default => ""
    t.integer  "state_id"
    t.string   "zip",                          :limit => 10,                                  :default => ""
    t.string   "phone1",                       :limit => 20,                                  :default => ""
    t.string   "phone2",                       :limit => 20
    t.string   "fax",                          :limit => 20,                                  :default => ""
    t.string   "email",                        :limit => 100
    t.string   "website",                      :limit => 100
    t.decimal  "delivery_radius",                              :precision => 6,  :scale => 2
    t.string   "comments",                     :limit => 500
    t.string   "description",                  :limit => 1000
    t.binary   "logo"
    t.decimal  "delivery_charge",                              :precision => 8,  :scale => 2
    t.string   "credit_card_number",           :limit => 45,                                  :default => ""
    t.integer  "credit_card_expiration_month"
    t.integer  "credit_card_expiration_year"
    t.integer  "credit_card_code"
    t.boolean  "delivery"
    t.boolean  "take_out"
    t.boolean  "dine_in"
    t.boolean  "late_night"
    t.boolean  "all_night"
    t.boolean  "specials"
    t.datetime "updated_at"
    t.integer  "status_id",                                                                   :default => 1
    t.string   "lat",                          :limit => 45
    t.string   "lng",                          :limit => 45
    t.string   "credit_card_first_name",       :limit => 45
    t.string   "credit_card_last_name",        :limit => 45
    t.integer  "credit_card_type_id"
    t.string   "account_number",               :limit => 20
    t.decimal  "delivery_minimum",                             :precision => 10, :scale => 2
    t.decimal  "credit_card_minimum",                          :precision => 10, :scale => 2
    t.integer  "admin_user_id",                                                                               :null => false
    t.boolean  "contract_signed"
    t.integer  "delivery_time"
    t.integer  "take_out_time"
    t.string   "county"
    t.decimal  "delivery_percent",                             :precision => 6,  :scale => 2
    t.string   "notes"
    t.boolean  "fax_enabled",                                                                                 :null => false
  end

  create_table "restaurants", :force => true do |t|
    t.string  "name",                         :limit => 100,                                 :default => "", :null => false
    t.string  "street1",                      :limit => 100,                                 :default => "", :null => false
    t.string  "street2",                      :limit => 100
    t.string  "city",                         :limit => 45,                                  :default => "", :null => false
    t.integer "state_id",                                                                                    :null => false
    t.string  "zip",                          :limit => 10,                                  :default => "", :null => false
    t.string  "phone1",                       :limit => 20,                                  :default => "", :null => false
    t.string  "phone2",                       :limit => 20
    t.string  "fax",                          :limit => 20,                                  :default => "", :null => false
    t.string  "email",                        :limit => 100
    t.string  "website",                      :limit => 100
    t.decimal "delivery_radius",                              :precision => 6,  :scale => 2
    t.string  "comments",                     :limit => 500
    t.string  "description",                  :limit => 1000
    t.decimal "delivery_charge",                              :precision => 8,  :scale => 2
    t.string  "credit_card_number",           :limit => 45
    t.integer "credit_card_expiration_month"
    t.integer "credit_card_expiration_year"
    t.integer "credit_card_code"
    t.boolean "delivery",                                                                                    :null => false
    t.boolean "take_out",                                                                                    :null => false
    t.boolean "dine_in",                                                                                     :null => false
    t.integer "version"
    t.integer "status_id",                                                                   :default => 1,  :null => false
    t.string  "lat",                          :limit => 45,                                  :default => "", :null => false
    t.string  "lng",                          :limit => 45,                                  :default => "", :null => false
    t.string  "credit_card_first_name",       :limit => 45
    t.string  "credit_card_last_name",        :limit => 45
    t.integer "credit_card_type_id"
    t.string  "account_number",               :limit => 20,                                  :default => "", :null => false
    t.decimal "delivery_minimum",                             :precision => 10, :scale => 2
    t.decimal "credit_card_minimum",                          :precision => 10, :scale => 2
    t.integer "admin_user_id",                                                                               :null => false
    t.boolean "contract_signed"
    t.integer "delivery_time"
    t.integer "take_out_time"
    t.string  "county"
    t.decimal "delivery_percent",                             :precision => 6,  :scale => 2
    t.string  "notes"
    t.boolean "fax_enabled",                                                                                 :null => false
  end

  add_index "restaurants", ["credit_card_type_id"], :name => "FK_restaurants_3"
  add_index "restaurants", ["state_id"], :name => "FK_restaurants_1"
  add_index "restaurants", ["status_id"], :name => "FK_restaurants_2"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :default => "", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "special_hour_versions", :force => true do |t|
    t.integer  "special_hour_id"
    t.integer  "version"
    t.integer  "item_size_id"
    t.decimal  "special_price",   :precision => 10, :scale => 2
    t.integer  "start_hour"
    t.integer  "start_minute"
    t.integer  "end_hour"
    t.integer  "end_minute"
    t.boolean  "sunday"
    t.boolean  "monday"
    t.boolean  "tuesday"
    t.boolean  "wednesday"
    t.boolean  "thursday"
    t.boolean  "friday"
    t.boolean  "saturday"
    t.integer  "status_id",                                      :default => 1
    t.datetime "updated_at"
  end

  create_table "special_hours", :force => true do |t|
    t.integer "item_size_id",                                                              :null => false
    t.decimal "special_price",              :precision => 10, :scale => 2,                 :null => false
    t.string  "start_hour",    :limit => 2,                                :default => "", :null => false
    t.string  "start_minute",  :limit => 2,                                :default => "", :null => false
    t.string  "end_hour",      :limit => 2,                                :default => "", :null => false
    t.string  "end_minute",    :limit => 2,                                :default => "", :null => false
    t.boolean "sunday",                                                                    :null => false
    t.boolean "monday",                                                                    :null => false
    t.boolean "tuesday",                                                                   :null => false
    t.boolean "wednesday",                                                                 :null => false
    t.boolean "thursday",                                                                  :null => false
    t.boolean "friday",                                                                    :null => false
    t.boolean "saturday",                                                                  :null => false
    t.integer "status_id",                                                 :default => 1,  :null => false
    t.integer "version"
  end

  add_index "special_hours", ["item_size_id"], :name => "FK_special_hours_1"
  add_index "special_hours", ["status_id"], :name => "FK_special_hours_2"

  create_table "states", :force => true do |t|
    t.string "abbr", :limit => 10, :default => "", :null => false
    t.string "name", :limit => 45, :default => "", :null => false
  end

  create_table "status", :force => true do |t|
    t.string "name", :limit => 45, :default => "", :null => false
  end

  create_table "sub_option_groups", :force => true do |t|
    t.integer "option_id",       :null => false
    t.integer "option_group_id", :null => false
  end

  create_table "take_out_hours", :force => true do |t|
    t.string  "start_hour",    :default => "", :null => false
    t.string  "end_hour",      :default => "", :null => false
    t.integer "restaurant_id",                 :null => false
    t.string  "start_minute",  :default => "", :null => false
    t.string  "end_minute",    :default => "", :null => false
    t.boolean "sunday",                        :null => false
    t.boolean "monday",                        :null => false
    t.boolean "tuesday",                       :null => false
    t.boolean "wednesday",                     :null => false
    t.boolean "thursday",                      :null => false
    t.boolean "friday",                        :null => false
    t.boolean "saturday",                      :null => false
  end

  create_table "taxes", :force => true do |t|
    t.integer "state_id",                                 :null => false
    t.decimal "sales_tax", :precision => 10, :scale => 3, :null => false
    t.decimal "food_tax",  :precision => 10, :scale => 3, :null => false
  end

  add_index "taxes", ["state_id"], :name => "FK_taxes_1"

  create_table "users", :force => true do |t|
    t.string   "phone",                        :limit => 20,  :default => "", :null => false
    t.string   "street1",                      :limit => 100
    t.string   "street2",                      :limit => 100
    t.string   "city",                         :limit => 100
    t.integer  "state_id"
    t.string   "zip",                          :limit => 10,  :default => "", :null => false
    t.string   "email",                        :limit => 100, :default => "", :null => false
    t.string   "crypted_password",             :limit => 40
    t.string   "salt",                         :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.integer  "privilege_id",                                                :null => false
    t.string   "lat",                          :limit => 45,  :default => "", :null => false
    t.string   "lng",                          :limit => 45,  :default => "", :null => false
    t.string   "activation_code",              :limit => 40
    t.datetime "activated_at"
    t.string   "forgot_password_code",         :limit => 40
    t.integer  "credit_card_type_id"
    t.string   "credit_card_number",           :limit => 45
    t.integer  "credit_card_expiration_month"
    t.integer  "credit_card_expiration_year"
    t.integer  "credit_card_code"
    t.string   "credit_card_first_name",       :limit => 100
    t.string   "credit_card_last_name",        :limit => 100
    t.string   "name",                                        :default => "", :null => false
  end

  add_index "users", ["credit_card_type_id"], :name => "FK_users_3"
  add_index "users", ["privilege_id"], :name => "FK_users_2"
  add_index "users", ["state_id"], :name => "FK_state1"

  create_table "weekdays", :force => true do |t|
    t.string "name", :limit => 45, :default => "", :null => false
  end

end
