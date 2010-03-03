module CuisineHelper
  
  def getRestaurantsForCuisine(restaurants, cuisine_id)
    restaurantsForCuisine = []
    
    restaurants.each do |restaurant|
      restaurant.cuisines.each do |cuisine|
        if cuisine.id == cuisine_id
          restaurantsForCuisine.push(restaurant)
          break
        end
      end
    end
  
    return restaurantsForCuisine
  end
  
  
end
