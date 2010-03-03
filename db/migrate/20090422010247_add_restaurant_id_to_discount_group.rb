class AddRestaurantIdToDiscountGroup < ActiveRecord::Migration
  def self.up
    add_column :discount_groups, :restaurant_id, :integer, :null => false
  end

  def self.down
    remove_column :discount_groups, :restaurant_id
  end
end
