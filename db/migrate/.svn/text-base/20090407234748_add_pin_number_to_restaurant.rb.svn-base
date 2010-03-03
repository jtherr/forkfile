class AddPinNumberToRestaurant < ActiveRecord::Migration
  def self.up
    add_column :restaurants, :pin_number, :integer, :null => false
  end

  def self.down
    remove_column :restaurants, :pin_number
  end
end
