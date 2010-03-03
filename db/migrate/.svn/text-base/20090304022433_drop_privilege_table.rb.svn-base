class DropPrivilegeTable < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE users DROP FOREIGN KEY FK_users_2"
    drop_table :privileges
  end

  def self.down
    create_table :privileges do |t|
      t.string  :name, :null => false
    end
  end
end
