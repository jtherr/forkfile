class OptionGroup < ActiveRecord::Base
  require 'config/constants.rb'
  
  acts_as_versioned
  
  belongs_to :restaurant
  has_many :item_option_groups
  has_many :options, :conditions => "status_id != #{$DELETED}"
  has_many :items, :through => :item_option_groups
  has_many :sub_option_groups

  has_many :discount_group_parts

  validates_presence_of      :name
  validates_length_of :description, :maximum => 100, :allow_blank => true
  validates_numericality_of  :min_selected, :only_integer => true, :greater_than_or_equal_to => 0, :allow_blank => true
  validates_numericality_of  :max_selected, :only_integer => true, :allow_blank => true
  validates_numericality_of  :quantity_price_increase, :only_integer => true, :allow_blank => true
  validates_numericality_of  :price_increase, :greater_than => 0, :allow_blank => true

  validates_uniqueness_of    :name, :scope => [:restaurant_id, :status_id]


  def validate
    if self.max_selected && self.min_selected && self.max_selected.to_i < self.min_selected.to_i
      errors.add(:max_selected, "must be greater than or equal to Min Selected")
    end
    
    if self.quantity_price_increase && self.max_selected && self.quantity_price_increase.to_i >= self.max_selected.to_i
      errors.add(:quantity_price_increase, "must be less than Max Selected")
    end
    
    if self.quantity_price_increase && !self.price_increase
      errors.add(:price_increase, "must be entered if Quantity Price Increase is entered")
    elsif !self.quantity_price_increase && self.price_increase
      errors.add(:quantity_price_increase, "must be entered if Price Increase is entered")
    end    
    
  end

  def version_updated_at(time)
    versions.find(:first, :conditions => "updated_at <= '#{time}'", :order => "updated_at desc")
  end
end
