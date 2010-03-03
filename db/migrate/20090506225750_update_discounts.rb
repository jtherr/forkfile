class UpdateDiscounts < ActiveRecord::Migration
  def self.up
    add_column :discounts, :get_for_amount, :decimal, :precision => 8, :scale => 2, :null => true
    add_column :discounts, :match_all_parts, :boolean, :null => true
  end

  def self.down
    remove_column :discounts, :get_for_amount
    remove_column :discounts, :match_all_parts
  end
end
