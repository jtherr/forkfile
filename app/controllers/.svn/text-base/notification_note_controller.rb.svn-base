class NotificationNoteController < ApplicationController

  before_filter :admin_required


  def search
    @status = 0
    
    if params[:notification] && params[:notification][:status]
      @status = params[:notification][:status]
    end
    
    @notification_search = params[:notification_search]
    
    @notifications = Notification.paginate :page => params[:page], :per_page => 20, :order => "date desc", :conditions => "(email LIKE '%#{@notification_search}%' OR message LIKE '%#{@notification_search}%') AND status = #{@status}"
    
    @title = "Search Notifications"
  end
  
  def showNotification
    @notification = Notification.find(params[:notificationId])
    @notes = @notification.notification_notes.find(:all, :order => "date desc")
        
    session[:notification_id] = params[:notificationId]
        
    if !@notification.viewed
      @notification.viewed = true
      @notification.save
    end
    
    @title = "Notification"
  end
  
  def addNotes
    @notification = Notification.find(session[:notification_id])
    
    @title = "Add Notes"
    
    render :partial => "addNotes"
  end
  
  
  def createNotes
    @notification = Notification.find(session[:notification_id])
    
    @notification_note = NotificationNote.new(params[:notification_note])
    
    @notification_note.notification_id = @notification.id
    @notification_note.user_id = current_user.id
    @notification_note.date = Time.now
    
    if @notification_note.save
      
      @notification.status = params[:notification][:status]
      @notification.save
      
      @notes = @notification.notification_notes.find(:all, :order => "date desc")
      render :partial => "notes"
    else
      @title = "Add Notes"
      
      render :partial => "addNotes", :status => 444
    end
  end
  
  def resolveNotification
    @notification = Notification.find(session[:notification_id])
    
    @notification.status = 1
    @notification.save
    
    render :partial => "notificationStatus"
  end
  
  def reopenNotification
    @notification = Notification.find(session[:notification_id])
    
    @notification.status = 0
    @notification.save
    
    render :partial => "notificationStatus"
  end
  
  def renderNotificationStatus
    @notification = Notification.find(session[:notification_id])
    render :partial => "notificationStatus"
  end
  

end
