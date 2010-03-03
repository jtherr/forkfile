module HoursExtension
  
  def validate
    check_weekdays()
  end
  
  
  def check_weekdays()
    if !self.sunday && !self.monday && !self.tuesday && !self.wednesday && !self.thursday && !self.friday && !self.saturday
      errors.add_to_base("At least one day must be selected")
    end
  end
  
  
  def start_time
    self.start_hour + ":" + self.start_minute
  end
  
  def end_time
    self.end_hour + ":" + self.end_minute
  end
  
  def parsed_start_time
    Time.parse(self.start_time)
  end
  
  def parsed_end_time
    Time.parse(self.end_time)
  end
  
  
  def start_time=(time)
    hour_minute = time.split(":")
    self.start_hour = hour_minute[0]
    self.start_minute = hour_minute[1]
  end
  
  def end_time=(time)
    hour_minute = time.split(":")
    self.end_hour = hour_minute[0]
    self.end_minute = hour_minute[1]
  end
  
  def isTimeWithin(time)
    self.weekdays.each do |weekday|
      opens = self.parsed_start_time
      closes = self.parsed_end_time
      
      if (opens >= closes)
        #CLOSES NEXT DAY
        
        if (startBeforeFinish(opens, time) && time.wday == weekday) || (startBeforeFinish(time, closes) && time.wday == next_weekday(weekday))
          return true
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
  
  def startBeforeFinish(start, finish)
    if start.hour < finish.hour
      return true
    elsif (start.hour == finish.hour) && (start.min <= finish.min)
      return true
    end
    
    return false
  end
  
  
  def next_weekday(weekday)
    weekday == 6 ? 0 : weekday + 1
  end
  
  def weekdays
    ids = []
    
    if self.sunday
      ids.push(0)
    end
    if self.monday
      ids.push(1)
    end
    if self.tuesday
      ids.push(2)
    end
    if self.wednesday
      ids.push(3)
    end
    if self.thursday
      ids.push(4)
    end
    if self.friday
      ids.push(5)
    end
    if self.saturday
      ids.push(6)
    end
    
    return ids
  end
  
end