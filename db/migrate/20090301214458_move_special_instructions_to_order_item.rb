class MoveSpecialInstructionsToOrderItem < ActiveRecord::Migration
  def self.up
    add_column :order_items, :special_instructions, :string
    remove_column :orders, :cooking_instructions
  end

  def self.down
    remove_column :order_items, :special_instructions
    add_column :orders, :cooking_instructions, :string
  end
end
