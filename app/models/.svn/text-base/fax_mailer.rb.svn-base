class FaxMailer < ActionMailer::Base
  helper :fax
  
  
  def order(o, fax)
    subject       'New Order'
    content_type  'text/plain'
    
    if fax
      recipients  '1' + o.restaurant.fax + '@myfax.com'
    else
      recipients  'jon.herr@forkfile.com'
    end
    
    from          'fax@forkfile.com'
    sent_on       Time.now
    
    body          :order =>  o
  end
    
  
end
