class SearchController < ApplicationController
  ssl_allowed :changeSearchAddress
  
  before_filter :admin_required, :only => [ :searchRestaurantsAdmin, :selectRestaurantAdmin ]

  before_filter :check_for_address, :except => [ :searchRestaurantsAdmin, :changeSearchAddress, :updateSearchAddress, :lookupCity ]
  
  
  def searchResults
        
    if session[:search_terms][:cuisine_id]
      tmp_cuisine_id = session[:search_terms][:cuisine_id]
      session[:search_terms][:cuisine_id] = nil
      
      tmp_restaurants = searchRestaurants()
      @cuisines = getCuisines(tmp_restaurants)
      
      session[:search_terms][:cuisine_id] = tmp_cuisine_id
      
      @restaurants = searchRestaurants()
    else
      @restaurants = searchRestaurants()
      @cuisines = getCuisines(@restaurants)
    end
    
    if logged_in?
      @favorites = current_user.favorites
    end
    
    @title = "Search Results"
  end
  
  def browse
    logger.debug("browse")
    
    if session[:search_terms] == nil
      session[:search_terms] = {}
    end
    
    session[:search_terms][:keywords] = nil
    session[:search_terms][:cuisine_id] = nil
    session[:search_terms][:delivery] = false
    session[:search_terms][:take_out] = false
    session[:search_terms][:specials] = false
    session[:search_terms][:open] = false
    session[:search_terms][:favorites] = false

    session[:search_terms][:return_to] = "restaurants"
    
    redirect_to :action => "searchResults"
  end
  
  
  def viewingHistory
    if session[:search_terms] == nil
      session[:search_terms] = {}
    end
    
    session[:search_terms][:keywords] = nil
    session[:search_terms][:cuisine_id] = nil
    session[:search_terms][:delivery] = false
    session[:search_terms][:take_out] = false
    session[:search_terms][:specials] = false
    session[:search_terms][:open] = false
    session[:search_terms][:favorites] = false
    
    @restaurants = searchRestaurants()
    @cuisines = getCuisines(@restaurants)
    
    if logged_in?
      @favorites = current_user.favorites
    end
    
    @title = "Viewing History"
    render :action => "searchResults"
  end
  
  
  def showCuisine
    if session[:search_terms] == nil
      session[:search_terms] = {}
    end
    
    session[:search_terms][:keywords] = nil
    session[:search_terms][:cuisine_id] = params[:id]
    session[:search_terms][:delivery] = false
    session[:search_terms][:take_out] = false
    session[:search_terms][:specials] = false
    session[:search_terms][:open] = false
    session[:search_terms][:favorites] = false
    
    session[:search_terms][:return_to] = "restaurants"
    
    redirect_to :action => "searchResults"
  end
  
  
  def basicSearch
    logger.debug("basicSearch")
    
    searchParams = params[:search]
    
    if session[:search_terms] == nil
      session[:search_terms] = {}
    end
    
    if searchParams != nil
      session[:search_terms][:keywords] = searchParams[:keywords]
    end
    
    session[:search_terms][:cuisine_id] = nil
    session[:search_terms][:delivery] = false
    session[:search_terms][:take_out] = false
    session[:search_terms][:specials] = false
    session[:search_terms][:open] = false
    session[:search_terms][:favorites] = false

    session[:search_terms][:return_to] = "restaurants"

    redirect_to :action => "searchResults"
  end
  
  def returnToRestaurants    
    if session[:search_terms] == nil
      session[:search_terms] = {}
    end

    redirect_to :action => "searchResults"
  end
  
  
  def searchRestaurantsAdmin
    @restaurant_search = params[:restaurant_search]
    
    @status_options = {
      0 => { :name => "ALL" },
      $ACTIVE => { :name => "Active" },
      $INACTIVE => { :name => "Inactive" },
      $DELETED => { :name => "Deleted" },
      $PENDING_APPROVAL => { :name => "Pending Approval" }
    }
    
    @status = params[:status] || 0
    if params[:restaurant] && params[:restaurant][:status]
      @status = params[:restaurant][:status]
    end
      
    if @status.to_i > 0
      status_condition = " AND status_id = #{@status}"
    else
      status_condition = ""
    end
        
    @restaurants = Restaurant.paginate :page => params[:page], :per_page => 20, :conditions => "name LIKE '%#{@restaurant_search}%' #{status_condition}", :order => "name"
    
    self.current_restaurant = nil
    
    @title = "Search Restaurants Admin: " + @status_options[@status.to_i][:name]
  end
  
  
  
  def showAllCuisines
    session[:search_terms][:cuisine_id] = nil
    @restaurants = searchRestaurants()
    
    if logged_in?
      @favorites = current_user.favorites
    end
    
    render :partial => "restaurantList"
  end
  
  def filterByCuisine
    session[:search_terms][:cuisine_id] = params[:id]
    @restaurants = searchRestaurants()
    
    logger.debug("delivery = #{session[:search_terms][:delivery]}")
    logger.debug("take_out = #{session[:search_terms][:take_out]}")
    logger.debug("cuisine_id = #{session[:search_terms][:cuisine_id]}")    
    
    if logged_in?
      @favorites = current_user.favorites
    end
    
    render :partial => "restaurantList"
  end
  
  
  def showAllOrderTypes
    session[:search_terms][:order_type] = nil
    @restaurants = searchRestaurants()
    
    if logged_in?
      @favorites = current_user.favorites
    end
    
    render :partial => "restaurantList"
  end
  
  def filterByDeliveryOn
    session[:search_terms][:delivery] = true
    @restaurants = searchRestaurants()
    
    logger.debug("delivery = #{session[:search_terms][:delivery]}")
    logger.debug("take_out = #{session[:search_terms][:take_out]}")
    logger.debug("cuisine_id = #{session[:search_terms][:cuisine_id]}")
        
    if logged_in?
      @favorites = current_user.favorites
    end
    
    render :partial => "restaurantList"
  end
  
  def filterByDeliveryOff
    session[:search_terms][:delivery] = false
    @restaurants = searchRestaurants()
    
    if logged_in?
      @favorites = current_user.favorites
    end
    
    render :partial => "restaurantList"
  end
  
  def filterByTakeoutOn
    session[:search_terms][:take_out] = true
    @restaurants = searchRestaurants()
    
    if logged_in?
      @favorites = current_user.favorites
    end
    
    render :partial => "restaurantList"
  end
  
  def filterByTakeoutOff
    session[:search_terms][:take_out] = false
    @restaurants = searchRestaurants()
    
    if logged_in?
      @favorites = current_user.favorites
    end
    
    render :partial => "restaurantList"
  end
  
  def filterBySpecialsOn
    session[:search_terms][:specials] = true
    @restaurants = searchRestaurants()
    
    if logged_in?
      @favorites = current_user.favorites
    end
    
    render :partial => "restaurantList"
  end
  
  def filterBySpecialsOff
    session[:search_terms][:specials] = false
    @restaurants = searchRestaurants()
    
    if logged_in?
      @favorites = current_user.favorites
    end
    
    render :partial => "restaurantList"
  end
  
  def filterByOpenOn
    session[:search_terms][:open] = true
    @restaurants = searchRestaurants()
    
    if logged_in?
      @favorites = current_user.favorites
    end
    
    render :partial => "restaurantList"
  end
  
  def filterByOpenOff
    session[:search_terms][:open] = false
    @restaurants = searchRestaurants()
    
    if logged_in?
      @favorites = current_user.favorites
    end
    
    render :partial => "restaurantList"
  end
  
  
  def refreshResults
    @restaurants = searchRestaurants()
    
    logger.debug("delivery = #{session[:search_terms][:delivery]}")
    logger.debug("take_out = #{session[:search_terms][:take_out]}")
    logger.debug("cuisine_id = #{session[:search_terms][:cuisine_id]}")
    
    if logged_in?
      @favorites = current_user.favorites
    end
    
    render :partial => "restaurantList"
  end
  
  
  def paginate
    @restaurants = searchRestaurants()
    
    if logged_in?
      @favorites = current_user.favorites
    end
    
    render :partial => "restaurantList"
  end
  
  def changeSearchAddress
    @title = "Edit Search Address"
    
    @address = current_address[:full] if current_address != nil
    
    render :partial => "changeSearchAddress"
  end
  
  def updateSearchAddress
    if session[:search_terms] == nil
      session[:search_terms] = {}
    end
    
    new_address = params[:search][:address]
    
    if new_address.empty?
      location = MultiGeocoder.geocode(request.remote_ip)
    else
      location = MultiGeocoder.geocode(new_address)
    end    

    @title = "Edit Search Address"
    
    if location.success
      if Restaurant.find(:first, :conditions => [ "status_id = ?", $ACTIVE ], :origin => location, :within => $DEFAULT_SEARCH_DISTANCE) == nil
        @address_invalid = true
        render :partial => "changeSearchAddress", :status => 444
      else
        setCurrentAddressFromLocation(location)
        clearDeliveryAddress()

        render :partial => "changeSearchAddress"
      end
    else
      @address_invalid = true
      render :partial => "changeSearchAddress", :status => 444
    end
  end
  
  def lookupCity
    session[:search_terms] = {}
    
    city = params[:city]
  
    location = MultiGeocoder.geocode(city)
    
    if location.success
      setCurrentAddressFromLocation(location)

      redirect_to :action => "basicSearch"
    else
      redirect_to :controller => "main", :action => "returnToHome"
    end
    
  end
  
  def selectRestaurantAdmin
    self.current_restaurant = Restaurant.find(params[:restaurantId])
    redirect_to :controller => "restaurant", :action => "showRestaurantAdmin"
  end
  
  
end
