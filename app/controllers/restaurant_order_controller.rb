class RestaurantOrderController < ApplicationController
  ssl_required :selectRestaurantOrders, :showRestaurantOrders, :refreshRestaurantOrders, :showRestaurantOrder
  
  before_filter :check_for_restaurant, :only => [ :showRestaurantOrders, :refreshRestaurantOrders ]
  
  before_filter :admin_required, :only => [ :showAllOrders ]
  
  
  def showMonthlyOrders
    if params[:restaurant_orders] != nil
      @month = params[:restaurant_orders][:month]
      @year = params[:restaurant_orders][:year]
    end

    time = $TIME_ZONE.now
    
    @years = (time.year - 5)..time.year
    @months = 1..12
    
    if @month == nil || @year == nil
      @month = time.month.to_i
      @year = time.year
    end
    
    time = Time.local(@year, @month)
    utcTime = $TIME_ZONE.local_to_utc(time)
    
    start = utcTime.strftime("%Y-%m-%d %H:%M:%S")
    finish = (utcTime + 1.month).strftime("%Y-%m-%d %H:%M:%S")
    
    @orders = Order.paginate :page => params[:page], :per_page => 20, 
        :select => "restaurant_id, COUNT(*) as num_orders, SUM(sub_total) as combined_total", 
        :conditions => [ "order_time >= ? and order_time < ?", start, finish], 
        :group => "restaurant_id"
        
    @orders.sort! { |a,b| a.restaurant.name <=> b.restaurant.name  }
        
    @title = "Orders for " + time.strftime("%B, %Y")
  end
  
  
  
  def restaurantOwnerCheck(restaurant)
    if !admin?
      found = false
      current_user.owned_restaurants.each do |owned_restaurant|
        if owned_restaurant.id == restaurant.id
          found = true
          break
        end
      end
      
      if !found
        redirect_to :controller => "main", :action => "index"
      end
    end
  end

  def selectRestaurantOrders
    self.current_restaurant = Restaurant.find(params[:id])
    redirect_to :action => "showRestaurantOrders"
  end


  def showRestaurantOrders
    restaurantOwnerCheck(current_restaurant)

    @orders = current_restaurant.orders.paginate :page => params[:page], :per_page => 20, :order => "order_time desc"
    @title = "Restaurant Orders - " + current_restaurant.name
  end
  
  def refreshRestaurantOrders
    restaurantOwnerCheck(current_restaurant)

    @orders = current_restaurant.orders.paginate :page => params[:page], :per_page => 20, :order => "order_time desc"

    render :partial => "restaurantOrders"
  end
  

  def showRestaurantOrder
    @order = Order.find(params[:restaurantOrderId])
    
    restaurantOwnerCheck(@order.restaurant)

    @title = "Restaurant Order"
  end


end