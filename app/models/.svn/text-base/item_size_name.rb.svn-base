class ItemSizeName < ActiveRecord::Base
  belongs_to :restaurant
  has_many :option_sizes
  has_many :item_sizes
  has_many :item_size_name_hours
  has_many :discount_group_parts

  validates_uniqueness_of :name, :scope => [:restaurant_id]


  def available?
    if self.item_size_name_hours.empty?
      return true
    end
    
    now = $TIME_ZONE.now
    
    self.item_size_name_hours.each do |hour|
      if hour.isTimeWithin(now)
        return true
      end
    end
    
    return false    
  end

end
