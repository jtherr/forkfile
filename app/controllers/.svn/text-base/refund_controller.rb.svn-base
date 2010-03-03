class RefundController < ApplicationController

  def refundRequest
    if logged_in?
      @email = current_user.email
    end
        
    @title = "Refund Request"
  end
  
  def refundRequestConfirmation
    
    @title = "Refund Request Confirmation"
  end
  

  def create
    @refund = Refund.new(params[:refund])
    
    @email = @refund.email
    
    if logged_in?
      @refund.user_id = current_user.id
    end
    
    @refund.request_date = Time.now
    @refund.status = 0
    
    if !@refund.save
      @title = "Refund Request"
      
      render :action => "refundRequest"
    else
      redirect_to :action => "refundRequestConfirmation"
    end
  end



end
