module RestaurantHelper

  def getAdditionalPrice(option_id, item_size_name_id)
    @optionSize = OptionSize.find(:first, :conditions => "item_size_name_id = #{item_size_name_id} and option_id = #{option_id}")
    
    if @optionSize
      return @optionSize.additional_price
    else
      return nil
    end
  end


  def getFavorite(restaurant, favorites)
    favorites.each do |favorite|
      if favorite.restaurant_id == restaurant.id
        return favorite
      end
    end
    
    return nil
  end


  def getSelectedLink(action)
    if @current_action == action
      return "selected"
    else
      return ""
    end
  end

end
