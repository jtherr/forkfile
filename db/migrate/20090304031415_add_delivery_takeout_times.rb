class AddDeliveryTakeoutTimes < ActiveRecord::Migration
  def self.up
    add_column :restaurants, :delivery_time, :integer, :null => true
    add_column :restaurant_versions, :delivery_time, :integer, :null => true
    add_column :restaurants, :take_out_time, :integer, :null => true
    add_column :restaurant_versions, :take_out_time, :integer, :null => true
  end

  def self.down
    remove_column :restaurants, :delivery_time
    remove_column :restaurant_versions, :delivery_time
    remove_column :restaurants, :take_out_time
    remove_column :restaurant_versions, :take_out_time
  end
end
