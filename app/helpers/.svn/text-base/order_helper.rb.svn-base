module OrderHelper
  
  def isSelected(option, all_selected_options)
    if all_selected_options == nil
      return option.selected_by_default
    else
      all_selected_options.each do |selected_option|
        if selected_option[:option_id].to_i == option.id
          return true
        end
      end
    end
    
    return false
  end
  
  def getQuantity(option, all_selected_options)
    if all_selected_options != nil
      all_selected_options.each do |selected_option|
        if selected_option[:option_id].to_i == option.id
          return selected_option[:quantity].to_i
        end
      end
    end
    
    return "1"
  end
  
  
  def isDeliveryAvailable(restaurant)
    return restaurant.delivery && restaurant.isDeliveryAvailable && ((restaurant.delivery_minimum == nil) || (session[:order][:total_price].to_f >= restaurant.delivery_minimum))
  end
  
  def isTakeOutAvailable(restaurant)
    return restaurant.take_out && restaurant.isTakeOutAvailable
  end
  
  
  def optionGroupInError(option_group_id, option_groups_in_error)
    if option_groups_in_error
      option_groups_in_error.each do |option_group_in_error|
        if option_group_id == option_group_in_error.to_i
          return true
        end
      end
    end
    
    return false
  end
  
  
  def getSelectOptionsMessage(min, max)
    message = ""
    
    if !min || min == 0
      if !max
        message = "Select from the following (optional):"
      else
        message = "Select up to #{max} of the following (optional):"
      end
      
    elsif max && min == max
      message = "Select #{min} of the following:"
    else
      if !max
        message = "Select at least #{min} of the following:"
      else
        message = "Select at least #{min} and at most #{max} of the following:"
      end
    end
    
    return message
  end
  
  
end
