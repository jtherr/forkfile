class ItemSizeNameHourController < ApplicationController
  
  before_filter :admin_required
  
  before_filter :check_for_restaurant
  
  def manageHours
    @item_size_name = ItemSizeName.find(params[:id])
    session[:item_size_name_id] = params[:id]
    
    @hours = @item_size_name.item_size_name_hours
    
    @title = "Change Item Size Hours"
  end
  
  
  def editHour
    @hour = ItemSizeNameHour.find(params[:id])
    @weekdays = Weekday.find(:all)
    
    @time_options = getTimeOptions()
    
    @title = "Edit Item Size Hours"
    
    render :partial => 'editHour'
  end
  
  def addHour
    @weekdays = Weekday.find(:all)
    
    @time_options = getTimeOptions()
    
    @title = "Add Item Size Hours"
    
    render :partial => 'addHour'
  end
  
  
  def createHour
    @item_size_name = ItemSizeName.find(session[:item_size_name_id])
    
    @hour = ItemSizeNameHour.new(params[:hour])
    
    @hour.item_size_name_id = @item_size_name.id
    
    if @hour.save
      @hours = @item_size_name.item_size_name_hours
      render :partial => "hours"
    else
      @weekdays = Weekday.find(:all)
      @time_options = getTimeOptions()
      
      @title = "Add Item Size Hours"
      
      render :partial => "addHour", :status => 444
    end
  end
  
  def updateHour
    @item_size_name = ItemSizeName.find(session[:item_size_name_id])
    
    @hour = ItemSizeNameHour.find(params[:id])
    
    if @hour.update_attributes(params[:hour])
      @hours = @item_size_name.item_size_name_hours
      render :partial => "hours"
    else
      @weekdays = Weekday.find(:all)
      @time_options = getTimeOptions()

      @title = "Edit Item Size Hours"

      render :partial => "editHour", :status => 444
    end
  end
  
  
  def deleteHour
    @item_size_name = ItemSizeName.find(session[:item_size_name_id])
    
    hour = ItemSizeNameHour.find(params[:id])
    
    if hour.destroy()
      @hours = @item_size_name.item_size_name_hours
      render :partial => "hours"
    else
      @hours = @item_size_name.item_size_name_hours
      render :partial => "hours", :status => 444
    end
    
  end
  
  
end