class ChangeItemSizePriceToAllowNull < ActiveRecord::Migration
  def self.up
    change_column :item_sizes, :price, :decimal, :precision => 8, :scale => 2, :null => true
    change_column :item_size_versions, :price, :decimal, :precision => 8, :scale => 2, :null => true
  end

  def self.down
    change_column :item_sizes, :price, :decimal, :precision => 8, :scale => 2, :null => false
    change_column :item_size_versions, :price, :decimal, :precision => 8, :scale => 2, :null => false
  end
end
