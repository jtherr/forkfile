class LocalityTax < ActiveRecord::Base
  belongs_to :state
  
  validates_presence_of :state_id
  validates_presence_of :meal_tax
  validates_numericality_of :meal_tax, :greater_than => 0
  
  def validate
    if self.county_name.empty? && self.city_name.empty?
      self.errors.add_to_base("County or City is required")
    elsif !self.county_name.empty? && !self.city_name.empty?
      self.errors.add_to_base("Please provide county OR city")
    end
    
  end
  
  
end