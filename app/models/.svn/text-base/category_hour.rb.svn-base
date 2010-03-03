class CategoryHour < ActiveRecord::Base
  include HoursExtension
  
  belongs_to :category
  
  validates_presence_of      :start_hour
  validates_presence_of      :start_minute
  validates_presence_of      :end_hour
  validates_presence_of      :end_minute
  
end
