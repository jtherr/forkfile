class EnableFaxByDefault < ActiveRecord::Migration
  def self.up
    add_column :restaurant_versions, :fax_enabled, :boolean, :null => true
        
    Restaurant.find(:all).each do |restaurant|
      restaurant.update_attributes(:fax_enabled => true)
    end
  end

  def self.down
    remove_column :restaurant_versions, :fax_enabled
    
    Restaurant.find(:all).each do |restaurant|
      restaurant.update_attributes(:fax_enabled => false)
    end
  end
end
