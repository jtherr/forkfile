class Refund < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :order
  belongs_to :restaurant
  has_many :refund_notes
  
  validates_presence_of     :reason
  validates_presence_of     :email
  validates_presence_of     :request_date
  validates_presence_of     :status


  def validate
    if self.restaurant_id == nil || self.order_id == nil
      errors.add_to_base("Account number and order number are invalid")
    else
      order = Order.find(self.order_id)
            
      if order == nil || order.restaurant_id != self.restaurant_id
        errors.add_to_base("Account number and order number are invalid")
      end
    end

  end
  
  
  def order_number=(value)    
    @order_number = value
    
    if value != nil && !value.empty?
      order = Order.find(:first, :conditions => "order_number = '#{value}'")
      
      if order != nil
        self.order_id = order.id
      end
    end
  end

  def order_number
    return @order_number
  end

  def account_number=(value)
    @account_number = value
    
    if value != nil && !value.empty?
      restaurant = Restaurant.find(:first, :conditions => "account_number = '#{value}'")
      
      if restaurant != nil
        self.restaurant_id = restaurant.id
      end
    end
  end
  
  def account_number
    return @account_number
  end
  
end
