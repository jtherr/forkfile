class AddPriceToOrderItem < ActiveRecord::Migration
  def self.up
    add_column :order_items, :price, :decimal, :precision => 8, :scale => 2, :null => false
  end

  def self.down
    remove_column :order_items, :price
  end
end
