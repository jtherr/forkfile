class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :item_size
  has_many :order_item_options
  
  validates_length_of :special_instructions, :maximum => 250, :allow_blank => true
  
  
  def orderOptionsInOptionGroup(option_group_id)
    options = []
    
    self.order_item_options.each do |order_item_option|
      if order_item_option.option.option_group.id == option_group_id
        options.push(order_item_option)
      end
    end
    
    return options
  end
  
end
