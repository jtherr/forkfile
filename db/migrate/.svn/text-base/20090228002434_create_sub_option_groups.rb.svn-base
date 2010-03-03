class CreateSubOptionGroups < ActiveRecord::Migration
  def self.up
     create_table :sub_option_groups do |t|
        t.integer  :option_id, :null => false
        t.integer  :option_group_id, :null => false
      end
  end

  def self.down
    drop_table :sub_option_groups
  end
end
