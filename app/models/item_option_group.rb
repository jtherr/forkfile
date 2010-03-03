class ItemOptionGroup < ActiveRecord::Base
  
  belongs_to :item
  belongs_to :option_group
  
  validates_presence_of :option_group_id
  validates_uniqueness_of :option_group_id, :scope => [:item_id]
  
end
