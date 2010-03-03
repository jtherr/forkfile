class AddDisclaimerRead < ActiveRecord::Migration
  def self.up
    add_column :orders, :disclaimer_read, :boolean, :null => false
  end

  def self.down
    remove_column :orders, :disclaimer_read
  end
end
