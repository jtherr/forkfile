class DiscountGroup < ActiveRecord::Base
  belongs_to :restaurant
  has_many :discount_group_parts, :dependent => :delete_all

  validates_presence_of :name


  def includesItem(item_size)
    item_size_name = item_size.item_size_name
    item = item_size.item
    category_id = item.category_id
        
    self.discount_group_parts.each do |discount_group_part|
      if discount_group_part.item_size_name_id
        if discount_group_part.item_size_name_id == item_size_name.id
          return discount_group_part
        end
      elsif discount_group_part.item_id
        if discount_group_part.item_id == item.id
          return discount_group_part
        end
      elsif discount_group_part.category_id == category_id
        return discount_group_part
      end
    end
    
    return nil
  end

  def matchingParts(item_size)
    item_size_name = item_size.item_size_name
    item = item_size.item
    category_id = item.category_id
        
    parts = [] 
       
    self.discount_group_parts.each do |discount_group_part|
      if discount_group_part.item_size_name_id
        if discount_group_part.item_size_name_id == item_size_name.id
          parts.push(discount_group_part)
        end
      elsif discount_group_part.item_id
        if discount_group_part.item_id == item.id
          parts.push(discount_group_part)
        end
      elsif discount_group_part.category_id == category_id
        parts.push(discount_group_part)
      end
    end
    
    return parts
  end



end