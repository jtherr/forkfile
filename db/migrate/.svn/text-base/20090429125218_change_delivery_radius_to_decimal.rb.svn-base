class ChangeDeliveryRadiusToDecimal < ActiveRecord::Migration
  def self.up
    change_column :restaurants, :delivery_radius, :decimal, :precision => 6, :scale => 2, :null => true
    change_column :restaurant_versions, :delivery_radius, :decimal, :precision => 6, :scale => 2, :null => true
  end

  def self.down
    change_column :restaurants, :delivery_radius, :integer, :null => true
    change_column :restaurant_versions, :delivery_radius, :integer, :null => true
  end
end
