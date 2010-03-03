class CreateRestaurantEmails < ActiveRecord::Migration
  def self.up
    create_table :restaurant_emails do |t|
      t.integer  :restaurant_id, :null => false
      t.string   :email, :null => false
    end
  end

  def self.down
    drop_table :restaurant_emails
  end
end
