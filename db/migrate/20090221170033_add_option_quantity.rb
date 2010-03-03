class AddOptionQuantity < ActiveRecord::Migration
  def self.up
    add_column :options, :allow_quantity, :boolean, :null => false
    add_column :option_versions, :allow_quantity, :boolean, :null => false
    add_column :order_item_options, :quantity, :integer, :null => true
  end

  def self.down
    remove_column :options, :allow_quantity
    remove_column :option_verions, :allow_quantity
    remove_column :order_item_options, :quantity
  end
end
