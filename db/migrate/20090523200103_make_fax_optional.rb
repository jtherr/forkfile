class MakeFaxOptional < ActiveRecord::Migration
  def self.up
    add_column :restaurants, :fax_enabled, :boolean, :null => false
  end

  def self.down
    remove_column :restaurants, :fax_enabled
  end
end
