class Discount < ActiveRecord::Base
  belongs_to :restaurant
  
  belongs_to :buy_discount_group, :class_name => "DiscountGroup", :foreign_key => "buy_discount_group_id"
  belongs_to :get_discount_group, :class_name => "DiscountGroup", :foreign_key => "get_discount_group_id"

  has_many :discount_hours

  validates_presence_of :name
  
  validates_length_of :description, :maximum => 250

  validates_numericality_of :buy_amount, :greater_than_or_equal_to => 0, :allow_blank => true
  validates_numericality_of :buy_quantity, :greater_than_or_equal_to => 0, :only_integer => true, :allow_blank => true
  
  validates_numericality_of :get_for_amount, :greater_than_or_equal_to => 0, :allow_blank => true
  validates_numericality_of :get_amount_off, :greater_than_or_equal_to => 0, :allow_blank => true
  validates_numericality_of :get_percent_off, :greater_than_or_equal_to => 0, :allow_blank => true
  validates_numericality_of :get_quantity, :greater_than_or_equal_to => 0, :only_integer => true, :allow_blank => true

  def validate
    if !self.take_out && !self.delivery
      self.errors.add_to_base("Must select delivery or take out")
    end
    
    if self.buy_discount_group != nil && !self.buy_match_all_parts && self.buy_quantity == nil
      self.errors.add_to_base("Please select a buy quantity")
    end

    if self.get_discount_group != nil && !self.get_match_all_parts && self.get_quantity == nil
      self.errors.add_to_base("Please select a get quantity")
    end
    
    if self.get_discount_group != nil && self.get_for_amount == nil && self.get_amount_off == nil && self.get_percent_off == nil
      self.errors.add_to_base("Please select a for amount, amount off, or percent off for the get discount group")
    end
    
    if self.get_discount_group == nil && self.get_amount_off == nil && self.get_percent_off == nil
      self.errors.add_to_base("Please select an amount off, percent off, or a discount group")
    end
    
  end


  def available?
    now = $TIME_ZONE.now
    
    if self.discount_hours.empty?
      return true
    end
    
    self.discount_hours.each do |hour|
      if hour.isTimeWithin(now)
        return true
      end
    end
    
    return false    
  end
  
  def current_discount_hour
    now = $TIME_ZONE.now
  
    self.discount_hours.each do |discount_hour|
      if discount_hour.isTimeWithin(now)
        return discount_hour
      end
    end
    
    return nil
  end
  
  def discount_hour_on_day(day_id)
    day_condition = ""
    case day_id
    when 0
      day_condition = "sunday = true"
    when 1
      day_condition = "monday = true"
    when 2
      day_condition = "tuesday = true"
    when 3
      day_condition = "wednesday = true"
    when 4
      day_condition = "thursday = true"
    when 5
      day_condition = "friday = true"
    when 6
      day_condition = "saturday = true"
    end    
    
    return self.discount_hours.find(:first, :conditions => day_condition)
  end



  def buy_options=(buy_options)  
  end

  def buy_options
    if self.buy_discount_group != nil
      return "items"
    elsif self.buy_amount != nil && self.buy_amount > 0
      return "amount"
    else
      return "anything"
    end
  end


  def get_options=(get_options)
  end

  def get_options
    if self.get_discount_group != nil
      return "items"
    elsif self.get_amount_off != nil && self.get_amount_off > 0
      return "amount_off"
    elsif self.get_percent_off != nil && self.get_percent_off > 0
      return "percent_off"
    else
      return ""
    end
  end

  def get_items_options=(get_items_options)
  end

  def get_items_options
    if self.get_for_amount != nil && self.get_for_amount > 0
      return "for_amount"
    elsif self.get_amount_off != nil && self.get_amount_off > 0
      return "amount_off"
    elsif self.get_percent_off != nil && self.get_percent_off > 0
      return "percent_off"
    else
      return ""
    end
  end

end
