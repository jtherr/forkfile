class RestaurantHourException < ActiveRecord::Base
  require 'config/constants.rb'
  
  belongs_to :restaurant
  
  validates_presence_of      :from_date
  validates_presence_of      :recurring_type
  validates_presence_of      :from_time, :unless => :closed
  validates_presence_of      :to_time, :unless => :closed
  validates_presence_of      :restaurant_id
  
  validates_inclusion_of     :closed, :in => [true, false]
  validates_inclusion_of     :recurring_type, :in => 0..5
  
  
  def match(now)
    todayMatched = matchDate(now)
    yesterdayMatched = matchDate(now - 1.day)
    
    if todayMatched && self.closed
      return true
    elsif matchTime(now, todayMatched, yesterdayMatched)
      return true
    end
    
    return false
  end
  
  
  def matchDate(now)
    found = false
    
    if self.recurring_type == $ONCE
      if now.year == self.from_date.year && now.month == self.from_date.month && now.day == self.from_date.day
        found = true
      end
    else
      if dateGreaterThanOrEqualTo(now, self.from_date) && (self.to_date == nil || dateGreaterThanOrEqualTo(self.to_date, now))
        
        if self.recurring_type == $DAILY
          found = true
        elsif self.recurring_type == $WEEKLY && now.wday == self.from_date.wday
          found = true
        elsif self.recurring_type == $MONTHLY_DAY_OF_WEEK && now.wday == self.from_date.wday
          if (now.mday / 7).round == (self.from_date.mday / 7).round
            found = true
          end
        elsif self.recurring_type == $MONTHLY_DAY_OF_MONTH && now.mday == self.from_date.mday
          found = true
        elsif self.recurring_type == $YEARLY && now.mday == self.from_date.mday && now.month == self.from_date.month
          found = true
        end
      end
    end
    
    return found
  end
  
  
  def matchTime(time, todayMatched, yesterdayMatched)
    opens = self.from_time
    closes = self.to_time

    if (opens >= closes)
      #CLOSES NEXT DAY
      
      if (startBeforeFinish(opens, time) && todayMatched) || (startBeforeFinish(time, closes) && yesterdayMatched)          
        return true
      end
    else
      #CLOSES TODAY        
      
      if startBeforeFinish(opens, time) && startBeforeFinish(time, closes) && todayMatched        
        return true
      end
    end
    
    return false
  end
  
  def startBeforeFinish(start, finish)
    if start.hour < finish.hour
      return true
    elsif (start.hour == finish.hour) && (start.min <= finish.min)
      return true
    end
    
    return false
  end
  
  
  def dateGreaterThanOrEqualTo(a, b)
    if a.year > b.year
      return true
    elsif a.year == b.year
      if a.month > b.month
        return true
      elsif a.month == b.month && a.day >= b.day
        return true
      end
    end
    
    return false
  end
  
end
