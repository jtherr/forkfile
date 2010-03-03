class AddSpecialsOnlyToItemSize < ActiveRecord::Migration
  def self.up
    add_column :item_sizes, :special_only, :boolean, :null => false
    add_column :item_size_versions, :special_only, :boolean, :null => false
  end

  def self.down
    remove_column :item_sizes, :special_only
    remove_column :item_size_versions, :special_only
  end
end
