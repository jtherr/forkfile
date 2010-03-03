class CreateDiscounts < ActiveRecord::Migration
  def self.up
    create_table :discounts do |t|
      t.string   :name, :null => false
      t.string   :description, :null => true
      t.integer  :buy_quantity, :null => false
      t.decimal  :buy_amount, :precision => 8, :scale => 2, :null => false
      t.integer  :buy_discount_group_id, :null => true
      t.integer  :get_quantity, :null => false
      t.decimal  :get_percent_off, :precision => 8, :scale => 2, :null => false
      t.decimal  :get_amount_off, :precision => 8, :scale => 2, :null => false
      t.integer  :get_discount_group_id, :null => true
      t.boolean  :allow_combo, :null => false
      t.boolean  :delivery, :null => false
      t.boolean  :take_out, :null => false
      t.integer  :priority, :null => false
    end

    create_table :discount_groups do |t|
      t.string   :name, :null => false
    end
  
    create_table :discount_group_items do |t|
      t.integer  :discount_group_id, :null => false
      t.integer  :item_id, :null => false
    end

    create_table :discount_group_categories do |t|
      t.integer  :discount_group_id, :null => false
      t.integer  :category_id, :null => false
    end

    create_table :discount_hours do |t|
      t.integer  :discount_id, :null => false
      t.string   :start_hour, :null => false
      t.string   :end_hour, :null => false
      t.string   :start_minute, :null => false
      t.string   :end_minute, :null => false
      t.boolean  :sunday, :null => false
      t.boolean  :monday, :null => false
      t.boolean  :tuesday, :null => false
      t.boolean  :wednesday, :null => false
      t.boolean  :thursday, :null => false
      t.boolean  :friday, :null => false
      t.boolean  :saturday, :null => false
    end
  end

  def self.down
    drop_table :discounts
    drop_table :discount_groups
    drop_table :discount_group_items
    drop_table :discount_group_categories
    drop_table :discount_hours
  end
end
