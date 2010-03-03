class AddPinNumberToRestaurantVersioned < ActiveRecord::Migration
  def self.up
    add_column :restaurant_versions, :pin_number, :integer, :null => false
  end

  def self.down
    remove_column :restaurant_versions, :pin_number
  end
end
