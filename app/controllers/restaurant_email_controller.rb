class RestaurantEmailController < ApplicationController
  before_filter :admin_required
  
  before_filter :check_for_restaurant
  
  def showOwnerEmails
    @restaurant_emails = current_restaurant.restaurant_emails
    @title = current_restaurant.name + ": Owner Emails"
  end
  
  
  def addOwnerEmail
    @title = "Add Owner Email"
    render :partial => "addOwnerEmail"
  end
  
  
  def createOwnerEmail    
    @restaurant_email = RestaurantEmail.new(params[:restaurant_email])
    @restaurant_email.restaurant_id = current_restaurant.id

    if !@restaurant_email.save
      @title = "Add Owner Email"
      
      render :partial => "addOwnerEmail", :status => 444
    else
      @restaurant_emails = current_restaurant.restaurant_emails
      
      render :partial => "ownerEmails"
    end
  end
  
  def removeOwnerEmail
    restaurant_email = RestaurantEmail.find(params[:id])
    restaurant_email.destroy

    @restaurant_emails = current_restaurant.restaurant_emails
    render :partial => "ownerEmails"
  end
  
  
end