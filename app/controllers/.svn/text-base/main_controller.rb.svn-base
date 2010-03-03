class MainController < ApplicationController  
  
  before_filter :admin_required, :only => [ :adminHome ]
  
  before_filter :run_captcha, :only => :createUser
    
  def index
    if logged_in?
      redirect_to :controller => "search", :action => "browse"
    else
      returnToHome()
    end
  end
  
  def returnToHome
    @title = 'Home'

    @address = current_address[:full] if current_address != nil
      
    if (session[:viewing_history] == nil || session[:viewing_history].empty?) && cookies[:viewing_history] != nil
      session[:viewing_history] = []
      cookies[:viewing_history].split(",").each do |vh|
        session[:viewing_history].push(vh.to_i)
      end
      session[:viewing_history].uniq!
    end
      
    render :action => "index", :layout => "home"
  end
  
  def adminHome
    @openRefundRequests = Refund.count(:conditions => "status = 0")
    @newRefundRequests = Refund.count(:conditions => "viewed = false")
    
    @openNotifications = Notification.count(:conditions => "status = 0")
    @newNotifications = Notification.count(:conditions => "viewed = false")
    
    @pendingApprovalCount = Restaurant.count(:conditions => "status_id = #{$PENDING_APPROVAL}")
    
    @title = "Admin Home"
  end
  
  def searchAddressFromHome
    session[:search_terms] = {}
    
    @address = params[:search][:address]
    
    if @address.empty?
      location = MultiGeocoder.geocode(request.remote_ip)
    else
      location = MultiGeocoder.geocode(@address)
    end
    
    if location.success
            
      if Restaurant.find(:first, :conditions => [ "status_id = ?", $ACTIVE ], :origin => location, :within => $DEFAULT_SEARCH_DISTANCE) == nil
        @address_invalid = true
        @title = 'Home'
      
        render :action => "index", :layout => "home"
      else
        setCurrentAddressFromLocation(location)
        clearDeliveryAddress()
        
        redirect_to :controller => "search", :action => "basicSearch"
      end
    else
      @address_invalid = true
      @title = 'Home'
    
      render :action => "index", :layout => "home"
    end
  end
  
  def faq
    @title = "FAQ"
  end
  
  def restaurantFaq
    @title = "Restaurant Owner FAQ"
  end
  
  def disclaimer
    @title = "Disclaimer"
  end
  
  
  def showCityMap
    @cities = Restaurant.find(:all, :group => "city, state_id", :select => "COUNT(*) as num_restaurants, city, state_id, lat, lng", :conditions => [ "status_id = ?", $ACTIVE])
    
    @title = "Where are our restaurants?"
    render :partial => "cityMap"
  end
  
end
