class SpecialController < ApplicationController

  def specials
    session[:search_terms][:specials_day_id] = nil
    session[:search_terms][:show_available_specials_only] = false
    
    session[:search_terms][:return_to] = "specials"
    
    searchSpecials()
    
    @title = "Specials"
  end
  
  def returnToSpecials
    @title = "Specials"
    
    render :action => "specials"
  end
  
  def showAllSpecials
    session[:search_terms][:specials_day_id] = nil
    session[:search_terms][:show_available_specials_only] = false

    searchSpecials()
    
    render :partial => "specialsList"
  end
  
  def showAvailableSpecials
    session[:search_terms][:specials_day_id] = nil
    session[:search_terms][:show_available_specials_only] = true
    
    searchSpecials()

    render :partial => "specialsList"
  end
  
  def filterSpecialsByDay
    session[:search_terms][:specials_day_id] = params[:id]
    session[:search_terms][:show_available_specials_only] = false

    searchSpecials()
    
    render :partial => "specialsList"
  end
  
  
  def refreshSpecials
    searchSpecials()
    render :partial => "specialsList"
  end
  
  def searchSpecials
    
    if session[:search_terms][:specials_day_id] != nil
      day_condition = ""
      case session[:search_terms][:specials_day_id].to_i
      when 0
        day_condition = "special_hours.sunday = true AND "
      when 1
        day_condition = "special_hours.monday = true AND "
      when 2
        day_condition = "special_hours.tuesday = true AND "
      when 3
        day_condition = "special_hours.wednesday = true AND "
      when 4
        day_condition = "special_hours.thursday = true AND "
      when 5
        day_condition = "special_hours.friday = true AND "
      when 6
        day_condition = "special_hours.saturday = true AND "
      end
      
      closeRestaurants = Restaurant.find(:all, :conditions => "status_id = #{$ACTIVE}", :origin => [session[:search_terms][:lat],session[:search_terms][:lng]], :order => "distance", :within => $DEFAULT_SEARCH_DISTANCE)

      tmp_restaurants_with_any_specials = []
      
      closeRestaurants.each do |restaurant|
        if !restaurant.discounts_on_day(session[:search_terms][:specials_day_id].to_i).empty?
          tmp_restaurants_with_any_specials.push(restaurant)
        end
      end
      
      tmp_restaurants_with_any_specials += Restaurant.find(:all, :include => { :items => { :item_sizes => :special_hours } }, :conditions => "#{day_condition} restaurants.status_id = #{$ACTIVE}", :origin => [current_address[:lat],current_address[:lng]], :order => "distance", :within => $DEFAULT_SEARCH_DISTANCE)

      @restaurants_with_any_specials = tmp_restaurants_with_any_specials.uniq.paginate :page => params[:page], :per_page => $DEFAULT_ITEMS_PER_PAGE, :origin => [current_address[:lat],current_address[:lng]], :order => "distance"

    else
        
      closeRestaurants = Restaurant.find(:all, :conditions => "status_id = #{$ACTIVE}", :origin => [current_address[:lat],current_address[:lng]], :order => "distance", :within => $DEFAULT_SEARCH_DISTANCE)
      
      tmp_restaurants_with_current_specials = []

      closeRestaurants.each do |restaurant|
        if restaurant.isOpen && (!restaurant.current_specials.empty? || !restaurant.current_discounts.empty?)
          tmp_restaurants_with_current_specials.push(restaurant)
        end
      end
      
      @restaurants_with_current_specials = tmp_restaurants_with_current_specials.uniq.paginate :page => params[:page], :per_page => $DEFAULT_ITEMS_PER_PAGE, :origin => [session[:search_terms][:lat],session[:search_terms][:lng]], :order => "distance"
    end
    
  end
  
  
end