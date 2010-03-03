class AddDeliveryPercentToRestaurant < ActiveRecord::Migration
  def self.up
    add_column :restaurants, :delivery_percent, :decimal, :precision => 6, :scale => 2, :null => true
    add_column :restaurant_versions, :delivery_percent, :decimal, :precision => 6, :scale => 2, :null => true
  end

  def self.down
    remove_column :restaurants, :delivery_percent
    remove_column :restaurant_versions, :delivery_percent
  end
end
