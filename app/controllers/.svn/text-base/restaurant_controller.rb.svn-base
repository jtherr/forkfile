class RestaurantController < ApplicationController
  include GeoKit::Geocoders
  
  before_filter :admin_required, :only => [ :showRestaurantAdmin, :addRestaurant, :modifyRestaurant, :removeRestaurant, :changeAcceptedCreditCards, :updateAcceptedCreditCards, :create, :update, :changeCuisines, :updateCuisines, :updateAcceptedCreditCards, :changeAcceptedCreditCards, :removeAcceptedCreditCards ]
  before_filter :super_admin_required, :only => [ :activate, :deactivate ]
  before_filter :check_for_restaurant, :except => [ :showRestaurant, :showSpecials, :addRestaurant, :create ]
  before_filter :check_for_address
  
  def showRestaurant
    if params[:id]
      restaurant_id = params[:id]
      self.current_restaurant = Restaurant.find(restaurant_id)
    elsif restaurant_stored?
      restaurant_id = current_restaurant.id
    else
      session_expired()
    end
    
    @restaurant = current_restaurant
    
    if session[:viewing_history] == nil
      session[:viewing_history] = []
    end
    session[:viewing_history].unshift(restaurant_id.to_i).uniq!
    session[:viewing_history] = session[:viewing_history][0..9]
    
    cookies[:viewing_history] = { :value => session[:viewing_history].join(","), :expires => 1.year.from_now }
    
        
    findItems(@restaurant, nil, nil)

    @singleColumn = false

    session[:category_id] = nil
    session[:item_search] = nil
    
    @title = @restaurant.name
  end
  
  def showRestaurantAdmin
    @restaurant = current_restaurant
    
    @activation_allowed = @restaurant.activation_allowed?
        
    @title = "Restaurant: " + @restaurant.name
  end
  
  def showSpecials
    if params[:id]
      restaurant_id = params[:id]
      self.current_restaurant = Restaurant.find(restaurant_id)
    elsif restaurant_stored?
      restaurant_id = current_restaurant.id
    else
      session_expired()
    end
    
    @restaurant = current_restaurant

    @specials = @restaurant.all_specials
    @discounts = @restaurant.discounts
    
    @title = @restaurant.name
  end
  
  
  def showMap
    @restaurant = current_restaurant

    @title = @restaurant.name
  end
  
  
  def showHours
    @restaurant = current_restaurant
    @hours = @restaurant.restaurant_hours
    @delivery_hours = @restaurant.delivery_hours
    @take_out_hours = @restaurant.take_out_hours

    @title = @restaurant.name
  end
  
  
  def showAdditionalInfo
    @restaurant = current_restaurant
    
    if logged_in?
      @favorite = @restaurant.favorite(current_user)
    end
    
    @hours = @restaurant.restaurant_hours
    @open = @restaurant.isOpen
        
    @title = "Restaurant Information"
  end
  
  
  def changeCuisines    
    @title = current_restaurant.name + ": Change Cuisines"
    @cuisines = Cuisine.find(:all, :order => "name")
  end
  
  def updateCuisines
    @restaurant_id = current_restaurant.id
    
    @restaurantCuisineParams = params[:restaurant_cuisine]
    
    @restaurantCuisineParams.each do |key, value|
      @restaurant_cuisine = RestaurantCuisine.find(:first, :conditions => "restaurant_id = #{@restaurant_id} and cuisine_id = #{key}")
      
      if value == "checked"
        if !@restaurant_cuisine
          @restaurant_cuisine = RestaurantCuisine.new()
          @restaurant_cuisine.restaurant_id = @restaurant_id
          @restaurant_cuisine.cuisine_id = key
          
          @restaurant_cuisine.save
        end
      else
        if @restaurant_cuisine
          @restaurant_cuisine.destroy()
        end
      end
    end
    
    redirect_to :action => 'showRestaurantAdmin', :id => @restaurant_id
  end
  
  
  
  def changeAcceptedCreditCards    
    @title = "Change Accepted Credit Cards"
    @credit_card_types = CreditCardType.find(:all)
  end
  
  def updateAcceptedCreditCards
    restaurant_id = current_restaurant.id
    
    restaurantCreditCardParams = params[:restaurant_credit_card]
    
    restaurantCreditCardParams.each do |key, value|
      @restaurant_credit_card = RestaurantCreditCard.find(:first, :conditions => "restaurant_id = #{restaurant_id} and credit_card_type_id = #{key}")
      
      if value == "checked"
        if !@restaurant_credit_card
          @restaurant_credit_card = RestaurantCreditCard.new()
          @restaurant_credit_card.restaurant_id = restaurant_id
          @restaurant_credit_card.credit_card_type_id = key
          
          @restaurant_credit_card.save
        end
      else
        if @restaurant_credit_card
          @restaurant_credit_card.destroy()
        end
      end
    end
    
    redirect_to :action => 'showRestaurantAdmin', :id => restaurant_id
  end
  
  
  
  def addRestaurant
    @states = State.find(:all)
    @credit_card_types = CreditCardType.find(:all)
    @months = 1..12
    
    year = Time.now.year
    @years = year..(year+5)   
    
    @restaurant = Restaurant.new(:fax_enabled => true)
    
    @title = "Add Restaurant"
  end
  
  def modifyRestaurant
    @restaurant = current_restaurant
    
    @credit_card_types = CreditCardType.find(:all)
    @states = State.find(:all)   
    @months = 1..12
    
    year = Time.now.year
    @years = year..(year+5)
    
    @title = "Modify Restaurant: " + @restaurant.name
  end
  
  def create
    @restaurant = Restaurant.new(params[:restaurant])
    
    @location = MultiGeocoder.geocode(@restaurant.address)
    
    @restaurant.lat = @location.lat
    @restaurant.lng = @location.lng
    
    @restaurant.item_size_names.build(:name => "")
    
    @restaurant.status_id = $PENDING_APPROVAL
    
    @restaurant.admin_user_id = current_user.id
    
    @restaurant.save
    if @restaurant.errors.empty?
      self.current_restaurant = @restaurant
      redirect_to :action => "showRestaurantAdmin", :restaurantId => @restaurant.id
      flash[:notice] = "Restaurant Created!"
    else
      @credit_card_types = CreditCardType.find(:all)
      @states = State.find(:all)   
      @months = 1..12
      
      year = Time.now.year
      @years = year..(year+5)
      
      @title = "Add Restaurant"      
      render :action => "addRestaurant"
    end
    
  end
  
  
  def update
    @restaurant = current_restaurant
    
    @restaurant.attributes = params[:restaurant]
    
    @location = MultiGeocoder.geocode(@restaurant.address)
    
    @restaurant.lat = @location.lat
    @restaurant.lng = @location.lng
    
    if @restaurant.save
      redirect_to :action => "showRestaurantAdmin", :id => @restaurant.id
      flash[:notice] = "Restaurant Updated!"
    else
      @credit_card_types = CreditCardType.find(:all)
      @states = State.find(:all)   
      @months = 1..12
      
      year = Time.now.year
      @years = year..(year+5)
      
      @title = "Modify Restaurant"
      render :action => "modifyRestaurant"
    end
  end
  
  def removeRestaurant
    @restaurant = current_restaurant
    @restaurant.update_attributes(:status_id => $DELETED)
    redirect_to :controller => "search", :action => "searchRestaurantsAdmin"
  end
  
  
  def changeCreditCard
    @restaurant = current_restaurant

    @months = 1..12
    
    year = Time.now.year
    @years = year..(year+5)
    
    @credit_card_types = CreditCardType.find(:all)
      
    @credit_card_type_id = ""
    @credit_card_number = ""
    @credit_card_expiration_month = ""
    @credit_card_expiration_year = ""
    @credit_card_code = ""
    @credit_card_first_name = ""
    @credit_card_last_name = ""
      
    @title = "Restaurant Credit Card"
  end
  
  def updateCreditCard
    @restaurant = current_restaurant
    
    if params['commit'] == "Cancel"
      redirect_to :controller => "restaurant", :action => "showRestaurantAdmin", :id => @restaurant.id

    else
      
      @credit_card_type_id = params[:restaurant][:credit_card_type_id]
      @credit_card_number = params[:restaurant][:credit_card_number]
      @credit_card_expiration_month = params[:restaurant][:credit_card_expiration_month]
      @credit_card_expiration_year = params[:restaurant][:credit_card_expiration_year]
      @credit_card_code = params[:restaurant][:credit_card_code]
      @credit_card_first_name = params[:restaurant][:credit_card_first_name]
      @credit_card_last_name = params[:restaurant][:credit_card_last_name]
      
      @restaurant.credit_card_type_id = params[:restaurant][:credit_card_type_id]
      @restaurant.credit_card_number = params[:restaurant][:credit_card_number]
      @restaurant.credit_card_expiration_month = params[:restaurant][:credit_card_expiration_month]
      @restaurant.credit_card_expiration_year = params[:restaurant][:credit_card_expiration_year]
      @restaurant.credit_card_code = params[:restaurant][:credit_card_code]
      @restaurant.credit_card_first_name = params[:restaurant][:credit_card_first_name]
      @restaurant.credit_card_last_name = params[:restaurant][:credit_card_last_name]
  
      @restaurant.validate_credit_card
      
      if @restaurant.errors.empty?
        @restaurant.save
        
        redirect_to :controller => "restaurant", :action => "showRestaurantAdmin", :id => @restaurant.id
      else    
        @months = 1..12
        
        year = Time.now.year
        @years = year..(year+5)
        
        @credit_card_types = CreditCardType.find(:all)
        
        @title = "Restaurant Credit Card"
        render :controller => "restaurant", :action => "changeCreditCard"
      end
    end
    
  end
  
  def removeCreditCard
    @restaurant = current_restaurant
    
    @restaurant.credit_card_type_id = nil
    @restaurant.credit_card_number = nil
    @restaurant.credit_card_expiration_month = nil
    @restaurant.credit_card_expiration_year = nil
    @restaurant.credit_card_code = nil
    @restaurant.credit_card_first_name = nil
    @restaurant.credit_card_last_name = nil

    @restaurant.save
    
    redirect_to :controller => "restaurant", :action => "showRestaurantAdmin", :id => @restaurant.id
  end


  def activate            
    current_restaurant.status_id = $ACTIVE
    
    if current_restaurant.save
      flash[:notice] = "Restaurant Activated!"
    end
    
    redirect_to :action => "showRestaurantAdmin", :id => current_restaurant.id
  end


  def deactivate            
    current_restaurant.status_id = $INACTIVE
    
    if current_restaurant.save
      flash[:notice] = "Restaurant Deactivated"
    end
    
    redirect_to :action => "showRestaurantAdmin", :id => current_restaurant.id
  end
  
  
  def editAdminNotes
    @restaurant = current_restaurant
    @title = "Edit Admin Notes"
    render :partial => "editAdminNotes"
  end
  
  def updateAdminNotes
    @restaurant = current_restaurant
    
    if @restaurant.update_attributes(:notes => params[:restaurant][:notes])
      render :partial => "adminNotes"
    else
      @title = "Edit Admin Notes"
      render :partial => "editAdminNotes", :status => 444
    end
    
  end
  
end
