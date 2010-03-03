class AddOwnerInfoToNotification < ActiveRecord::Migration
  def self.up
    add_column :notifications, :name, :string, :null => true  
    add_column :notifications, :phone, :string, :null => true
    add_column :notifications, :restaurant_name, :string, :null => true  
    add_column :notifications, :street1, :string, :null => true  
    add_column :notifications, :street2, :string, :null => true  
    add_column :notifications, :city, :string, :null => true  
    add_column :notifications, :state_id, :integer, :null => true  
    add_column :notifications, :zip, :string, :null => true  
  end

  def self.down
    remove_column :notifications, :name
    remove_column :notifications, :phone
    remove_column :notifications, :restaurant_name
    remove_column :notifications, :street1
    remove_column :notifications, :street2
    remove_column :notifications, :city
    remove_column :notifications, :state_id
    remove_column :notifications, :zip    
  end
end
