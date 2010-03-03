class ItemSize < ActiveRecord::Base
  require 'config/constants.rb'
  
  acts_as_versioned

  belongs_to :item
  belongs_to :item_size_name
  has_many :option_sizes, :conditions => "status_id != #{$DELETED}"
  has_many :special_hours, :conditions => "special_hours.status_id != #{$DELETED}"
  has_one :restaurant, :through => :item
  
  validates_numericality_of :price, :greater_than => 0, :unless => :special_only


  def version_updated_at(time)
    versions.find(:first, :conditions => "updated_at <= '#{time}'", :order => "updated_at desc")
  end
  
  def available?
    return !self.special_only || special_available?
  end

  
  def special_available?
    now = $TIME_ZONE.now
    
    self.special_hours.each do |hour|
      if hour.isTimeWithin(now)
        return true
      end
    end
    
    return false    
  end
  
  def current_price
    now = $TIME_ZONE.now
    
    self.special_hours.each do |hour|
      if hour.isTimeWithin(now)
        return hour.special_price
      end
    end
    
    return self.price  
  end
  
  def current_special
    now = $TIME_ZONE.now
    
    self.special_hours.each do |hour|
      if hour.isTimeWithin(now)
        return hour
      end
    end
    
    return nil
  end
  
  
  def price_at_time(old_time)    
    self.special_hours.each do |hour|
      if hour.isTimeWithin(old_time)
        return hour.special_price
      end
    end
    
    return self.price  
  end
  
end
