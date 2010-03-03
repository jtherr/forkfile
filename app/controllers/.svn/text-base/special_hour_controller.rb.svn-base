class SpecialHourController < ApplicationController
  
  before_filter :admin_required
  
  before_filter :check_for_restaurant  
  
  def manageHours
    @item_size = ItemSize.find(params[:id])
    session[:item_size_id] = params[:id]
    
    @hours = @item_size.special_hours
    
    @title = @item_size.item.restaurant.name + ": Change Specials"
  end
  
  
  def editHour
    @hour = SpecialHour.find(params[:id])
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
    @item_size = ItemSize.find(session[:item_size_id])
    
    @hour = SpecialHour.new(params[:hour])
    
    @hour.item_size_id = @item_size.id
    
    if @hour.save
      @hours = @item_size.special_hours
      render :partial => "hours"
    else
      @weekdays = Weekday.find(:all)
      @time_options = getTimeOptions()
      
      render :partial => "addHour", :status => 444
    end
  end
  
  def updateHour
    @item_size = ItemSize.find(session[:item_size_id])
    
    @hour = SpecialHour.find(params[:id])
    
    if @hour.update_attributes(params[:hour])
      @hours = @item_size.special_hours
      render :partial => "hours"
    else
      @weekdays = Weekday.find(:all)
      @time_options = getTimeOptions()

      render :partial => "editHour", :status => 444
    end
  end
  
  
  def deleteHour
    @item_size = ItemSize.find(session[:item_size_id])
    
    hour = SpecialHour.find(params[:id])
    
    hour.update_attributes(:status_id => $DELETED)

    @hours = @item_size.special_hours
    render :partial => "hours"
  end
  
end