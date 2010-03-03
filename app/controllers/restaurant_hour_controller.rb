class RestaurantHourController < ApplicationController
  
  before_filter :admin_required
  before_filter :check_for_restaurant
  
  def manageHours
    @restaurant = current_restaurant
    @hours = @restaurant.restaurant_hours
    @hour_exceptions = @restaurant.restaurant_hour_exceptions
    @delivery_hours = @restaurant.delivery_hours
    @take_out_hours = @restaurant.take_out_hours
    
    @title = @restaurant.name + ": Manage Restaurant Hours"
  end
  
  
  def editHour
    @hour = RestaurantHour.find(params[:id])
    @weekdays = Weekday.find(:all)
    
    @time_options = getTimeOptions()
    
    render :partial => 'editHour'
  end
  
  def addHour
    @weekdays = Weekday.find(:all)
    
    @time_options = getTimeOptions()
    
    render :partial => 'addHour'
  end
  
  def editDeliveryHour
    @delivery_hour = DeliveryHour.find(params[:id])
    @weekdays = Weekday.find(:all)
    
    @time_options = getTimeOptions()
    
    render :partial => 'editDeliveryHour'
  end
  
  def addDeliveryHour
    @weekdays = Weekday.find(:all)
    
    @time_options = getTimeOptions()
    
    render :partial => 'addDeliveryHour'
  end
  
  
  def editTakeOutHour
    @take_out_hour = TakeOutHour.find(params[:id])
    @weekdays = Weekday.find(:all)
    
    @time_options = getTimeOptions()
    
    render :partial => 'editTakeOutHour'
  end
  
  def addTakeOutHour
    @weekdays = Weekday.find(:all)
    
    @time_options = getTimeOptions()
    
    render :partial => 'addTakeOutHour'
  end
  
  def editHourException
    @hour_exception = RestaurantHourException.find(params[:id])
    
    @time_options = getTimeOptions()
    
    render :partial => 'editHourException'
  end
  
  def addHourException
    @time_options = getTimeOptions()
    
    render :partial => 'addHourException'
  end
  
  
  def createHour
    @restaurant = current_restaurant
    
    @hour = RestaurantHour.new(params[:hour])
    
    @hour.restaurant_id = @restaurant.id
    
    if @hour.save
      @hours = @restaurant.restaurant_hours
      render :partial => "hours"
    else
      @weekdays = Weekday.find(:all)
      @time_options = getTimeOptions()
      
      render :partial => "addHour", :status => 444
    end
  end
  
  def updateHour
    @restaurant = current_restaurant
    
    @hour = RestaurantHour.find(params[:id])
    
    if @hour.update_attributes(params[:hour])
      @hours = @restaurant.restaurant_hours
      render :partial => "hours"
    else
      @weekdays = Weekday.find(:all)
      @time_options = getTimeOptions()

      render :partial => "editHour", :status => 444
    end
  end
  
  
  def deleteHour
    @restaurant = current_restaurant
    
    hour = RestaurantHour.find(params[:id])
    
    if hour.destroy()
      @hours = @restaurant.restaurant_hours
      render :partial => "hours"
    else
      @hours = @restaurant.restaurant_hours
      render :partial => "hours", :status => 444
    end
    
  end
  


  
  def createDeliveryHour
    @restaurant = current_restaurant
    
    @delivery_hour = DeliveryHour.new(params[:delivery_hour])
    
    @delivery_hour.restaurant_id = @restaurant.id
    
    if @delivery_hour.save
      @delivery_hours = @restaurant.delivery_hours
      render :partial => "deliveryHours"
    else
      @weekdays = Weekday.find(:all)
      @time_options = getTimeOptions()
      
      render :partial => "addDeliveryHour", :status => 444
    end
  end
  
  def updateDeliveryHour
    @restaurant = current_restaurant
    
    @delivery_hour = DeliveryHour.find(params[:id])
    
    if @delivery_hour.update_attributes(params[:delivery_hour])
      @delivery_hours = @restaurant.delivery_hours
      render :partial => "deliveryHours"
    else
      @weekdays = Weekday.find(:all)
      @time_options = getTimeOptions()

      render :partial => "editDeliveryHour", :status => 444
    end
  end
  
  
  def deleteDeliveryHour
    @restaurant = current_restaurant
    
    delivery_hour = DeliveryHour.find(params[:id])
    
    if delivery_hour.destroy()
      @delivery_hours = @restaurant.delivery_hours
      render :partial => "deliveryHours"
    else
      @delivery_hours = @restaurant.delivery_hours
      render :partial => "deliveryHours", :status => 444
    end
    
  end
  

  def createTakeOutHour
    @restaurant = current_restaurant
    
    @take_out_hour = TakeOutHour.new(params[:take_out_hour])
    
    @take_out_hour.restaurant_id = @restaurant.id
    
    if @take_out_hour.save
      @take_out_hours = @restaurant.take_out_hours
      render :partial => "takeOutHours"
    else
      @weekdays = Weekday.find(:all)
      @time_options = getTimeOptions()
      
      render :partial => "addTakeOutHour", :status => 444
    end
  end
  
  def updateTakeOutHour
    @restaurant = current_restaurant
    
    @take_out_hour = TakeOutHour.find(params[:id])
    
    if @take_out_hour.update_attributes(params[:take_out_hour])
      @take_out_hours = @restaurant.take_out_hours
      render :partial => "takeOutHours"
    else
      @weekdays = Weekday.find(:all)
      @time_options = getTimeOptions()

      render :partial => "editTakeOutHour", :status => 444
    end
  end
  
  
  def deleteTakeOutHour
    @restaurant = current_restaurant
    
    take_out_hour = TakeOutHour.find(params[:id])
    
    if take_out_hour.destroy()
      @take_out_hours = @restaurant.take_out_hours
      render :partial => "takeOutHours"
    else
      @take_out_hours = @restaurant.take_out_hours
      render :partial => "takeOutHours", :status => 444
    end
    
  end
  


  def createHourException
    @restaurant = current_restaurant
    
    @hour_exception = RestaurantHourException.new(params[:hour_exception])
    
    @hour_exception.restaurant_id = @restaurant.id
    
    if @hour_exception.save
      @hour_exceptions = @restaurant.restaurant_hour_exceptions
      render :partial => "hourExceptions"
    else
      @time_options = getTimeOptions()
      
      render :partial => "addHourException", :status => 444
    end
  end
  
  def updateHourException
    @restaurant = current_restaurant
    
    @hour_exception = RestaurantHourException.find(params[:id])
    
    if @hour_exception.update_attributes(params[:hour_exception])
      @hour_exceptions = @restaurant.restaurant_hour_exceptions
      render :partial => "hourExceptions"
    else
      @time_options = getTimeOptions()

      render :partial => "editHourException", :status => 444
    end
  end
  
  
  def deleteHourException
    @restaurant = current_restaurant
    
    hour_exception = RestaurantHourException.find(params[:id])
    
    if hour_exception.destroy()
      @hour_exceptions = @restaurant.restaurant_hour_exceptions
      render :partial => "hourExceptions"
    else
      @hour_exceptions = @restaurant.restaurant_hour_exceptions
      render :partial => "hourExceptions", :status => 444
    end
    
  end
  
  
end