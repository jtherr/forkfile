class NotificationMailer < ActionMailer::Base
  
  def notification(note)
    setup_email()

    body[:notification] = note
  end

  def restaurantOwnerConfirmation(email)
    @recipients  = email
    @from        = "noreply@forkfile.com"
    @subject     = "Forkfile.com - Thank you for your request"
    @sent_on     = Time.now
  end
  
  def restaurantOwnerNotification(note)
    setup_email()
    @subject += " - Restaurant Owner Inquiry"
    
    body[:notification] = note
  end
  
    
  protected
    def setup_email()
      @recipients  = "support@forkfile.com"
      @from        = "noreply@forkfile.com"
      @subject     = "forkfile.com - Notification"
      @sent_on     = Time.now
    end
end
