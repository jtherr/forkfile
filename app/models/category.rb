class Category < ActiveRecord::Base
  require 'config/constants.rb'
  
  belongs_to :restaurant
  has_many :items, :conditions => "status_id != #{$DELETED}"
  has_many :category_hours
  has_many :discount_group_parts

  validates_presence_of      :name
  validates_uniqueness_of    :name, :scope => [:restaurant_id]

  
  def available?
    if !self.restaurant.isOpen
      return false
    end
    
    if self.category_hours.empty?
      return true
    end
    
    now = $TIME_ZONE.now
    
    self.category_hours.each do |hour|
      if hour.isTimeWithin(now)
        return true
      end
    end
    
    return false    
  end
  
  
  def item_size_names  
    names = []
    self.items.each do |item|
      names += item.item_size_names
    end
  
    return names.uniq
  end
  
end
