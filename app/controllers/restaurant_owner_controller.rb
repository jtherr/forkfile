class RestaurantOwnerController < ApplicationController
  before_filter :admin_required
  
  before_filter :check_for_restaurant
  
  def showLinkedRestaurantOwners
    @restaurant = current_restaurant
    @restaurant_owners = @restaurant.restaurant_owners
    @title = @restaurant.name + ": Owner Web Access"
  end
  
  def addRestaurantOwner
    @title = "Add Owner Web Access"
    render :partial => "addRestaurantOwner"
  end
  
  def addRestaurantOwnerAccount
    @states = State.find(:all)
    @title = "Add New Owner Account & Link Web Access"
    render :partial => "addRestaurantOwnerAccount"
  end
  
  
  def linkRestaurantOwner
    email = params[:email]
    
    owner = User.find(:first, :conditions => [ "email = ?", email ] )
    
    @restaurant_owner = RestaurantOwner.new(:restaurant_id => current_restaurant.id)
    
    if owner != nil
      @restaurant_owner.user_id = owner.id
    end
    
    if !@restaurant_owner.save
      @title = "Add Owner Web Access"
      
      render :partial => "addRestaurantOwner", :status => 444
    else
      @restaurant_owners = current_restaurant.restaurant_owners
      
      sendExistingOwnerAccountInfo(@restaurant_owner.user, current_restaurant)
      
      render :partial => "linkedRestaurantOwners"
    end
  end
  
  def unlinkRestaurantOwner
    restaurant_owner = RestaurantOwner.find(params[:id])
    restaurant_owner.destroy

    @restaurant_owners = current_restaurant.restaurant_owners
    render :partial => "linkedRestaurantOwners"
  end
  
  
  def createRestaurantOwnerAndLink
    @user = User.new(params[:user])

    random_password = (0...8).map{65.+(rand(25)).chr}.join
    
    @user.password = random_password
    @user.password_confirmation = random_password
    @user.privilege_id = $CUSTOMER

    location = MultiGeocoder.geocode(@user.address)
    
    @user.lat = location.lat
    @user.lng = location.lng
    
    if !@user.save
      @states = State.find(:all)
      @title = "Add New Owner Account & Link Web Access"
      render :partial => "addRestaurantOwnerAccount", :status => 444
    else
      @restaurant_owner = RestaurantOwner.new(:restaurant_id => current_restaurant.id, :user_id => @user.id)
      
      if !@restaurant_owner.save
        @title = "Add Owner Web Access"
        
        render :partial => "addRestaurantOwner", :status => 444
      else
        @restaurant_owners = current_restaurant.restaurant_owners
        
        sendNewOwnerAccountInfo(@user, current_restaurant)
        
        render :partial => "linkedRestaurantOwners"
      end
    end
    
  end

  
  def sendNewOwnerAccountInfo(user, restaurant)
    user.forgot_password_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    
    user.save(false)
    
    UserMailer.deliver_newOwnerAccountInfo(user, restaurant)  
  end
  
  
  def sendExistingOwnerAccountInfo(user, restaurant)    
    UserMailer.deliver_existingOwnerAccountInfo(user, restaurant)  
  end
  
end
