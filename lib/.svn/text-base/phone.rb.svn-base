module Phone
  require 'lib/twiliorest.rb'
  
  def makeCall(called, url)
    account = TwilioRest::Account.new($TWILIO_ACCOUNT_SID, $TWILIO_ACCOUNT_TOKEN)
 
    data = {
        'Caller' => '877-211-4104',
        'Called' => called,
        'Url' => url,
    }
    
    account.request("/#{$TWILIO_API_VERSION}/Accounts/#{$TWILIO_ACCOUNT_SID}/Calls", 'POST', data)
  end
  
end
