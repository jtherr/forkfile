class AddCountyToRestaurantVersion < ActiveRecord::Migration
  def self.up
    add_column :restaurant_versions, :county, :string, :null => true
  end

  def self.down
    remove_column :restaurant_versions, :county
  end
end
