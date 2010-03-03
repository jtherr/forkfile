module RestaurantTracker
  
  protected
    
    def restaurant_stored?
      !!current_restaurant
    end

    def current_restaurant
      @current_restaurant ||= restaurantFromSession unless @current_restaurant == false
    end

    def current_restaurant=(new_restaurant)
      if new_restaurant != nil
        session[:restaurant_id] = new_restaurant.id
      else
        session[:restaurant_id] = nil
      end

      @current_restaurant = new_restaurant || false
    end
    
    def restaurantFromSession      
      self.current_restaurant = Restaurant.find(session[:restaurant_id]) if (session[:restaurant_id] != nil)
    end

    def self.included(base)
      base.send :helper_method, :current_restaurant, :restaurant_stored?
    end
  
end
