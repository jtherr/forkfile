xml.instruct!
xml.Response do

	phone1 = @phone.split(//)[0..2].join(". ")
	phone2 = @phone.split(//)[3..5].join(". ")
	phone3 = @phone.split(//)[6..9].join(". ")

	if @phone.length > 10
		extension = ".. extension. " + @phone.split(//)[10..-1].join(". ")
	end

	xml.Gather(:action => "https://forkfile.com/phone/orderScript?phone=" + @phone, :numDigits => 1, :timeout => 10) do
		xml.Play "http://forkfile.com/sounds/alert.mp3"
		
		xml.Say "You have received an order from forkfile."
		xml.Say "Please check your fax machine."
		xml.Say "If you are having trouble receiving the fax, please contact the customer at... #{phone1}.. #{phone2}.. #{phone3} #{extension}."
		xml.Say "If you would like to repeat this message, press 1."
	end
end 
