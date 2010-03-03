class PhoneController < ApplicationController

  ssl_required :orderScript
  
  def orderScript
    @phone = params[:phone]

    respond_to do |format|  
      format.xml { @phone }  
    end  
  end

  def answer
    respond_to do |format|  
      format.xml  
    end
  end
  
end