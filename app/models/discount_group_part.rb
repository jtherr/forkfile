class DiscountGroupPart < ActiveRecord::Base
  belongs_to :discount_group
  belongs_to :item
  belongs_to :category
  belongs_to :item_size_name
  belongs_to :option_group
  
  validates_presence_of :category_id
  validates_numericality_of :option_group_quantity, :only_integer => true, :greater_than_or_equal_to => 0, :allow_blank => true
end