class ItemSizeNameHour < ActiveRecord::Base
  include HoursExtension

  belongs_to :item_size_name
  
  validates_presence_of      :start_hour
  validates_presence_of      :start_minute
  validates_presence_of      :end_hour
  validates_presence_of      :end_minute

end
