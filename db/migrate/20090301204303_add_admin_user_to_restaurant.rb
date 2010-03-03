class AddAdminUserToRestaurant < ActiveRecord::Migration
  def self.up
    add_column :restaurants, :admin_user_id, :integer, :null => false
    add_column :restaurant_versions, :admin_user_id, :integer, :null => false
  end

  def self.down
    remove_column :restaurants, :admin_user_id
    remove_column :restaurant_versions, :admin_user_id
  end
end
