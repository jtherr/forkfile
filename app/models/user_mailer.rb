class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
  
    @body[:url]  = "http://forkfile.com/activate/#{user.activation_code}"
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://forkfile.com/"
  end
  
  def forgotPassword(user)
    setup_email(user)
    @subject    += 'Forgot Password'
    @body[:url]  = "http://forkfile.com/changePassword/#{user.forgot_password_code}"
  end
  
  def order_confirmation(order)    
    @recipients  = order.email
    @from        = "noreply@forkfile.com"
    @subject     = "forkfile.com - Order Confirmation"
    @sent_on     = Time.now
    
    @body[:order] = order
    @content_type = "text/html"
  end
  
  def restaurant_order(order, email)
    @recipients  = email
    @from        = "noreply@forkfile.com"
    @sent_on     = Time.now
    
    if order.order_type == "delivery"
      @subject    = 'forkfile.com - New Order for ***DELIVERY***' 
    else
      @subject    = 'forkfile.com - New Order for Take Out' 
    end
    
    @body[:order] = order
    @content_type = "text/html"
  end
  
  def newOwnerAccountInfo(user, restaurant)
    setup_email(user)
    @subject    += 'Your Restaurant Owner Account'
    @content_type = "text/html"
    @body[:url]  = "http://forkfile.com/ownerAccount/#{user.forgot_password_code}"
    @body[:restaurant] = restaurant
  end
  
  
  def existingOwnerAccountInfo(user, restaurant)
    setup_email(user)
    @subject    += 'Your Restaurant Owner Account'
    @content_type = "text/html"
    @body[:restaurant] = restaurant
  end
    
    
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "noreply@forkfile.com"
      @subject     = "forkfile.com - "
      @sent_on     = Time.now
      @body[:user] = user
    end
end
