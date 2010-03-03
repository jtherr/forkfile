class RevampDiscounts < ActiveRecord::Migration
  def self.up
    create_table :discount_group_parts do |t|
      t.integer  :discount_group_id, :null => false
      t.integer  :category_id, :null => true
      t.integer  :item_id, :null => true
      t.integer  :item_size_name_id, :null => true
      t.integer  :option_group_id, :null => true
      t.integer  :option_group_quantity, :null => true
    end
  
    DiscountGroupItem.find(:all).each do |discount_group_item|
      category_id = discount_group_item.item.category.id
      
      DiscountGroupPart.new(:discount_group_id => discount_group_item.discount_group_id, :item_id => discount_group_item.item_id, :category_id => category_id).save
    end

    DiscountGroupCategory.find(:all).each do |discount_group_category|
      DiscountGroupPart.new(:discount_group_id => discount_group_category.discount_group_id, :category_id => discount_group_category.category_id).save
    end
  
    drop_table   :discount_group_items
    drop_table   :discount_group_categories
  end

  def self.down    
    create_table :discount_group_items do |t|
      t.integer  :discount_group_id, :null => false
      t.integer  :item_id, :null => false
    end

    create_table :discount_group_categories do |t|
      t.integer  :discount_group_id, :null => false
      t.integer  :category_id, :null => false
    end
    
    DiscountGroupPart.find(:all).each do |discount_group_part|
      if discount_group_part.item_id
        DiscountGroupItem.new(:discount_group_id => discount_group_part.discount_group_id, :item_id => discount_group_part.item_id).save
      end
      if discount_group_part.category_id
        DiscountGroupCategory.new(:discount_group_id => discount_group_part.discount_group_id, :category_id => discount_group_part.category_id).save
      end
    end
    
    drop_table   :discount_group_parts
  end
end
