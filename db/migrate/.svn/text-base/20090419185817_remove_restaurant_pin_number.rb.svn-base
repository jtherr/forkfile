class RemoveRestaurantPinNumber < ActiveRecord::Migration
  def self.up
    remove_column :restaurants, :pin_number
    remove_column :restaurant_versions, :pin_number
  end

  def self.down
    add_column :restaurants, :pin_number, :integer, :null => false
    add_column :restaurant_versions, :pin_number, :integer, :null => false
  end
end
