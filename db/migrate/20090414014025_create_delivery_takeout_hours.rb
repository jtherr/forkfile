class CreateDeliveryTakeoutHours < ActiveRecord::Migration
  def self.up
     create_table  :delivery_hours do |t|
        t.string   :start_hour, :null => false
        t.string   :end_hour, :null => false
        t.integer  :restaurant_id, :null => false
        t.string   :start_minute, :null => false
        t.string   :end_minute, :null => false
        t.boolean  :sunday, :null => false
        t.boolean  :monday, :null => false
        t.boolean  :tuesday, :null => false
        t.boolean  :wednesday, :null => false
        t.boolean  :thursday, :null => false
        t.boolean  :friday, :null => false
        t.boolean  :saturday, :null => false
     end
    
     create_table  :take_out_hours do |t|
        t.string   :start_hour, :null => false
        t.string   :end_hour, :null => false
        t.integer  :restaurant_id, :null => false
        t.string   :start_minute, :null => false
        t.string   :end_minute, :null => false
        t.boolean  :sunday, :null => false
        t.boolean  :monday, :null => false
        t.boolean  :tuesday, :null => false
        t.boolean  :wednesday, :null => false
        t.boolean  :thursday, :null => false
        t.boolean  :friday, :null => false
        t.boolean  :saturday, :null => false
      end
  end

  def self.down
  end
end
