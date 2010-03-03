class RefundNoteController < ApplicationController

  before_filter :admin_required


  def search
    @status = 0
    
    if params[:refund] && params[:refund][:status]
      @status = params[:refund][:status]
    end
    
    @refund_search = params[:refund_search]
    
    @refunds = Refund.paginate :page => params[:page], :per_page => 20, :order => "request_date desc", :conditions => "(email LIKE '%#{@refund_search}%' OR reason LIKE '%#{@refund_search}%') AND status = #{@status}"
    
    @title = "Search Refund Requests"
  end
  
  def showRefundRequest
    @refund = Refund.find(params[:refundId])
    @notes = @refund.refund_notes.find(:all, :order => "date desc")
        
    session[:refund_id] = params[:refundId]
        
    if !@refund.viewed
      @refund.viewed = true
      @refund.save
    end
    
    @title = "Refund Request"
  end
  
  def addNotes
    @refund = Refund.find(session[:refund_id])
    
    @title = "Add Notes"
    
    render :partial => "addNotes"
  end
  
  def changeStatus
    @refund = Refund.find(session[:refund_id])

    @title = "Change Status"
    
    render :partial => "addNotes"
  end
  
  
  def createNotes
    @refund = Refund.find(session[:refund_id])
    
    @refund_note = RefundNote.new(params[:refund_note])
    
    @refund_note.refund_id = @refund.id
    @refund_note.user_id = current_user.id
    @refund_note.date = Time.now
    
    if @refund_note.save
      
      @refund.status = params[:refund][:status]
      @refund.grant_date = Time.now
      @refund.grant_amount = params[:refund][:grant_amount]
      @refund.save
      
      @notes = @refund.refund_notes.find(:all, :order => "date desc")
      render :partial => "notes"
    else
      @title = "Add Notes"
      
      render :partial => "addNotes", :status => 444
    end
  end
  
  def renderRefundInfo
    @refund = Refund.find(session[:refund_id])
    render :partial => "refundInfo"
  end
  

end
