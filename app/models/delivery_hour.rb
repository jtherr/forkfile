class DeliveryHour < ActiveRecord::Base
  include HoursExtension

  belongs_to :restaurant
  
  validates_presence_of      :start_hour
  validates_presence_of      :start_minute
  validates_presence_of      :end_hour
  validates_presence_of      :end_minute
  
end
