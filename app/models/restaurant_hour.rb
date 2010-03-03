class RestaurantHour < ActiveRecord::Base
  include HoursExtension

  belongs_to :restaurant
  
  validates_presence_of      :start_hour
  validates_presence_of      :start_minute
  validates_presence_of      :end_hour
  validates_presence_of      :end_minute
  
  def isTimeWithin(time, exceptionYesterdayClosed)
    
    self.weekdays.each do |weekday|
      opens = self.parsed_start_time
      closes = self.parsed_end_time

      if (opens >= closes)
        #CLOSES NEXT DAY
        
        if (startBeforeFinish(opens, time) && time.wday == weekday) || (startBeforeFinish(time, closes) && time.wday == next_weekday(weekday))          
          if exceptionYesterdayClosed
            return false
          else
            return true
          end
        end
      else
        #CLOSES TODAY        
        
        if startBeforeFinish(opens, time) && startBeforeFinish(time, closes) && (time.wday == weekday)          
          return true
        end
      end
    end
    
    return false
  end

end
