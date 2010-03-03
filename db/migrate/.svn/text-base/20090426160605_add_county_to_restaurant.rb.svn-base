class AddCountyToRestaurant < ActiveRecord::Migration
  def self.up
    add_column :restaurants, :county, :string, :null => true
  end

  def self.down
    remove_column :restaurants, :county
  end
end
