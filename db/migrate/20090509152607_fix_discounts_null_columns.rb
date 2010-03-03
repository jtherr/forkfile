class FixDiscountsNullColumns < ActiveRecord::Migration
  def self.up
    change_column :discounts, :buy_quantity, :integer, :null => true
    change_column :discounts, :buy_amount, :decimal, :precision => 8, :scale => 2, :null => true
    change_column :discounts, :get_quantity, :integer, :null => true
    change_column :discounts, :get_amount_off, :decimal, :precision => 8, :scale => 2, :null => true
    change_column :discounts, :get_percent_off, :decimal, :precision => 8, :scale => 2, :null => true
  end

  def self.down
    change_column :discounts, :buy_quantity, :integer, :null => false
    change_column :discounts, :buy_amount, :decimal, :precision => 8, :scale => 2, :null => false
    change_column :discounts, :get_quantity, :integer, :null => false
    change_column :discounts, :get_amount_off, :decimal, :precision => 8, :scale => 2, :null => false
    change_column :discounts, :get_percent_off, :decimal, :precision => 8, :scale => 2, :null => false
  end
end
