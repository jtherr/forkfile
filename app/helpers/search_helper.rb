module SearchHelper
  
  def getOrderTypeSelected(order_type)
    if session[:search_terms][:order_type] == order_type
      return "selected"
    end
    
    return ""
  end


end
