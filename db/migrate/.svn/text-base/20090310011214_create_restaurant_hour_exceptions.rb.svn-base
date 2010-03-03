class CreateRestaurantHourExceptions < ActiveRecord::Migration
  def self.up
     create_table  :restaurant_hour_exceptions do |t|
        t.date     :from_date, :null => false
        t.date     :to_date, :null => true
        t.integer  :recurring_type, :null => false
        t.boolean  :closed, :null => false
        t.time     :from_time, :null => true
        t.time     :to_time, :null => true
        t.integer  :restaurant_id, :null => false
      end
  end

  def self.down
    drop_table :restaurant_hour_exceptions
  end
end
