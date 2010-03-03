class ChangeUserName < ActiveRecord::Migration
  def self.up
    add_column :users, :name, :string, :null => false
    
    User.find(:all).each do |user|
      user.name = user.first_name + " " + user.last_name
      user.save
    end
    
    remove_column :users, :first_name
    remove_column :users, :middle_initial
    remove_column :users, :last_name
  end

  def self.down
    add_column :users, :first_name, :string, :null => true
    add_column :users, :middle_initial, :string, :null => true
    add_column :users, :last_name, :string, :null => true

    User.find(:all).each do |user|
      name = user.name
      
      if name != nil
        name_parts = name.split(" ", 2)
        
        if name_parts[0] != nil
          user.first_name = name_parts[0]
        end
        
        if name_parts[1] != nil
          user.last_name = name_parts[1]
        end
        
        user.save
      end
    end

    remove_column :users, :name
  end
end
