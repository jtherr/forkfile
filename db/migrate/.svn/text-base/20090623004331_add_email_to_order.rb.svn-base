class AddEmailToOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :email, :string, :null => false
  end

  def self.down
    remove_column :orders, :email
  end
end
