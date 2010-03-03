class AddRestaurantNotes < ActiveRecord::Migration
  def self.up
    add_column :restaurants, :notes, :string
    add_column :restaurant_versions, :notes, :string
  end

  def self.down
    remove_column :restaurants, :notes
    remove_column :restaurant_versions, :notes
  end
end
