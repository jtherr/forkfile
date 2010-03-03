class SpecialHour < ActiveRecord::Base
  include HoursExtension

  acts_as_versioned

  belongs_to :item_size

  validates_presence_of      :start_hour
  validates_presence_of      :start_minute
  validates_presence_of      :end_hour
  validates_presence_of      :end_minute
  validates_presence_of      :special_price
    
  validates_numericality_of :special_price, :greater_than => 0

end
