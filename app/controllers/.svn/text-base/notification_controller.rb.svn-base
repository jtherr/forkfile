class NotificationController < ApplicationController

  before_filter :run_captcha, :only => [ :create, :createRestaurantNotification ]

  def contactUs
    if logged_in?
      @email = current_user.email
    end
    
    @reasons = NotificationReason.find(:all)
    
    @title = "Contact Us"
  end
  
  def restaurantOwners
    @states = State.find(:all)
    @title = "Restaurant Owners"
  end
  
  def confirmation
    
    @title = "Thank you for contacting us"
  end
  

  def create
    @notification = Notification.new(params[:notification])
    
    @email = @notification.email
    
    if logged_in?
      @notification.user_id = current_user.id
    end
    
    @notification.date = Time.now
    @notification.status = 0
    
    if !@notification.save
      @reasons = NotificationReason.find(:all)
      @title = "Contact Us"
            
      render :action => "contactUs"
    else
      NotificationMailer.deliver_notification(@notification)
      
      @title = "Confirmation"
      redirect_to :action => :confirmation
    end
  end


  def createRestaurantNotification
    @notification = Notification.new(params[:notification])
    
    notification_reason = NotificationReason.find(:first, :conditions => "name = 'Restaurant - Interested in service'")
    
    if notification_reason == nil
      notification_reason = NotificationReason.new(:name => 'Restaurant - Interested in service')
      notification_reason.save
    end
    
    @notification.date = Time.now
    @notification.status = 0
    @notification.notification_reason_id = notification_reason.id
    
    if !@notification.save
      @states = State.find(:all)
      @title = "Restaurant Owners"
            
      render :action => "restaurantOwners"
    else
      NotificationMailer.deliver_restaurantOwnerConfirmation(@notification.email)
      NotificationMailer.deliver_restaurantOwnerNotification(@notification)
      
      @title = "Confirmation"
      redirect_to :action => :confirmation
    end
  end


end
