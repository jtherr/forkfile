module AddressTracker
  include GeoKit::Geocoders  
  
  protected
    
    def address_stored?
      !!current_address
    end

    def current_address
      @current_address ||= (addressFromSession || addressFromCurrentUser || addressFromCookie) unless @current_address == false
    end

    def current_address=(new_address)
      session[:address] = new_address
      
      if new_address != nil
        cookies[:address] = { :value => new_address[:full], :expires => 1.year.from_now }
      else
        cookies.delete :address
      end

      @current_address = new_address || false
    end
    
    
    def addressFromSession      
      self.current_address = session[:address] if (session[:address] != nil && !session[:address].empty?)
    end
    
    def addressFromCurrentUser
      if logged_in?        
        new_address = {}
        new_address[:street1] = current_user.street1
        new_address[:street2] = current_user.street2
        new_address[:city] = current_user.city
        new_address[:state_id] = current_user.state_id
        new_address[:zip] = current_user.zip

        new_address[:lat] = current_user.lat
        new_address[:lng] = current_user.lng
        new_address[:full] = current_user.address
        
        self.current_address = new_address
      end
    end
    
    def addressFromCookie
      if (cookies[:address] != nil && !cookies[:address].empty?)
        location = MultiGeocoder.geocode(cookies[:address])
        setCurrentAddressFromLocation(location)
      end
    end
    
    
    def setCurrentAddressFromCurrentUser
      if current_user != nil
        new_address = {}
        new_address[:street1] = current_user.street1
        new_address[:street2] = current_user.street2
        new_address[:city] = current_user.city
        new_address[:state_id] = current_user.state_id
        new_address[:zip] = current_user.zip
      
        new_address[:lat] = current_user.lat
        new_address[:lng] = current_user.lng

        new_address[:full] = current_user.address

        self.current_address = new_address
      end
    end
  
  
    def setCurrentAddressFromLocation(location)
      if location != nil && location.success
        state = State.find(:first, :conditions => [ "abbr = ?", location.state ])
        
        if state != nil
          new_address = {}
          new_address[:street1] = location.street_address
          new_address[:street2] = ""
          new_address[:city] = location.city
          new_address[:state_id] = state.id
          new_address[:zip] = location.zip
        
          new_address[:lat] = location.lat
          new_address[:lng] = location.lng
        
          new_address[:full] = getFullAddressFromLocation(location)
        
          self.current_address = new_address
        else
          logger.error "Successful geocode, but unable to find state: " + location.state
        end
      end
    end
    
    def getFullAddressFromLocation(location)
      value = ""
      if location.street_address && !location.street_address.empty?
        value += location.street_address + ", "
      end
      if location.city && !location.city.empty?
        value += location.city + ", "
      end
      if location.state && !location.state.empty?
        value += location.state + " "
      end
      if location.zip && !location.zip.empty?
        value += location.zip
      end
      
      return value
    end
    
    
    
    def clearDeliveryAddress
      if session[:order] != nil
        session[:order][:delivery_street1] = nil
        session[:order][:delivery_street2] = nil
        session[:order][:delivery_city] = nil
        session[:order][:delivery_state_id] = nil
        session[:order][:delivery_zip] = nil
      end
    end
  
    def self.included(base)
      base.send :helper_method, :current_address, :address_stored?, :clearDeliveryAddress
    end
  
end
