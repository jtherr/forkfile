class FixPrices < ActiveRecord::Migration
  def self.up
    change_column :item_sizes, :price, :decimal, :precision => 8, :scale => 2, :null => false
    change_column :item_size_versions, :price, :decimal, :precision => 8, :scale => 2, :null => false
    change_column :bills, :bill_amount, :decimal, :precision => 8, :scale => 2, :null => false
    change_column :option_groups, :price_increase, :decimal, :precision => 8, :scale => 2, :null => true
    change_column :option_group_versions, :price_increase, :decimal, :precision => 8, :scale => 2, :null => true
    change_column :option_sizes, :additional_price, :decimal, :precision => 8, :scale => 2, :null => true, :default => nil
    change_column :option_size_versions, :additional_price, :decimal, :precision => 8, :scale => 2, :null => true, :default => nil
    change_column :restaurants, :delivery_charge, :decimal, :precision => 8, :scale => 2, :null => true
    change_column :restaurant_versions, :delivery_charge, :decimal, :precision => 8, :scale => 2, :null => true
  end

  def self.down
    change_column :item_sizes, :price, :decimal, :precision => 10, :scale => 0, :null => false
    change_column :item_size_versions, :price, :decimal, :precision => 10, :scale => 0, :null => true
    change_column :bills, :bill_amount, :integer, :null => false
    change_column :option_groups, :price_increase, :string, :limit => 10, :null => true
    change_column :option_group_versions, :price_increase, :string, :limit => 10, :null => true
    change_column :option_sizes, :additional_price, :string, :limit => 45, :null => true, :default => nil
    change_column :option_size_versions, :additional_price, :string, :limit => 45, :null => true, :default => nil
    change_column :restaurants, :delivery_charge, :decimal, :precision => 10, :scale => 0, :null => true
    change_column :restaurant_versions, :delivery_charge, :decimal, :precision => 10, :scale => 0, :null => true
  end
end
