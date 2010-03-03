class CategoryHourController < ApplicationController
  
  before_filter :admin_required
  
  before_filter :check_for_restaurant
  
  def manageHours
    @category = Category.find(params[:id])
    session[:category_id] = params[:id]
    
    @hours = @category.category_hours
    
    @title = "Change Category Hours"
  end
  
  
  def editHour
    @hour = CategoryHour.find(params[:id])
    @weekdays = Weekday.find(:all)
    
    @time_options = getTimeOptions()
    
    render :partial => 'editHour'
  end
  
  def addHour
    @weekdays = Weekday.find(:all)
    
    @time_options = getTimeOptions()
    
    render :partial => 'addHour'
  end
  
  
  def createHour
    @category = Category.find(session[:category_id])
    
    @hour = CategoryHour.new(params[:hour])
    
    @hour.category_id = @category.id
    
    if @hour.save
      @hours = @category.category_hours
      render :partial => "hours"
    else
      @weekdays = Weekday.find(:all)
      @time_options = getTimeOptions()
      
      render :partial => "addHour", :status => 444
    end
  end
  
  def updateHour
    @category = Category.find(session[:category_id])
    
    @hour = CategoryHour.find(params[:id])
    
    if @hour.update_attributes(params[:hour])
      @hours = @category.category_hours
      render :partial => "hours"
    else
      @weekdays = Weekday.find(:all)
      @time_options = getTimeOptions()

      render :partial => "editHour", :status => 444
    end
  end
  
  
  def deleteHour
    @category = Category.find(session[:category_id])
    
    hour = CategoryHour.find(params[:id])
    
    if hour.destroy()
      @hours = @category.category_hours
      render :partial => "hours"
    else
      @hours = @category.category_hours
      render :partial => "hours", :status => 444
    end
    
  end
  
  
end