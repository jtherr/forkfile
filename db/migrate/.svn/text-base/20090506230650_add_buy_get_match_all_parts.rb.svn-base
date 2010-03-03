class AddBuyGetMatchAllParts < ActiveRecord::Migration
  def self.up
    add_column :discounts, :get_match_all_parts, :boolean, :null => true
    add_column :discounts, :buy_match_all_parts, :boolean, :null => true
    remove_column :discounts, :match_all_parts
  end

  def self.down
    add_column :discounts, :match_all_parts, :boolean, :null => true
    remove_column :discounts, :get_match_all_parts
    remove_column :discounts, :buy_match_all_parts
  end
end
