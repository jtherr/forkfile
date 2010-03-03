class FixNotificationOrderNumber < ActiveRecord::Migration
  def self.up
    change_column :notifications, :order_number, :string, :null => true
  end

  def self.down
    change_column :notifications, :order_number, :integer, :null => true
  end
end
