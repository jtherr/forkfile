class AddRestaurantIdToDiscounts < ActiveRecord::Migration
  def self.up
    add_column :discounts, :restaurant_id, :integer, :null => false
  end

  def self.down
    remove_column :discounts, :restaurant_id
  end
end
