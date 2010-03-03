class RemoveUnneededRestProps < ActiveRecord::Migration
  def self.up
    remove_column :restaurants, :specials
    remove_column :restaurants, :late_night
    remove_column :restaurants, :all_night
  end

  def self.down
    add_column :restaurants, :specials, :boolean, :null => false
    add_column :restaurants, :late_night, :boolean, :null => false
    add_column :restaurants, :all_night, :boolean, :null => false
  end
end
