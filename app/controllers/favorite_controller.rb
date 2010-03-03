class FavoriteController < ApplicationController
  
  
  def returnToFavorites
    temp_cuisine_id = session[:search_terms][:cuisine_id]

    session[:search_terms][:cuisine_id] = nil
    
    @restaurants = searchRestaurants()
    @cuisines = getCuisines(@restaurants)
    
    session[:search_terms][:cuisine_id] = temp_cuisine_id

    @favorites = current_user.favorites

    @title = "Favorites"
    
    render :action => "favorites"
  end
  
  
  def favorites
    session[:search_terms][:keywords] = nil
    session[:search_terms][:cuisine_id] = nil
    session[:search_terms][:delivery] = false
    session[:search_terms][:take_out] = false
    session[:search_terms][:specials] = false
    session[:search_terms][:open] = false
    session[:search_terms][:favorites] = true
    
    session[:search_terms][:return_to] = "favorites"
    
    @restaurants = searchRestaurants()
    @favorites = current_user.favorites
    
    @cuisines = getCuisines(@restaurants)
    
    @title = "Favorites"
  end
  
  def addFavorite
    if logged_in?
      @favorite = Favorite.new()
      @favorite.restaurant_id = params[:id]
      @favorite.user_id = current_user.id
      @favorite.save
      
      @restaurant = @favorite.restaurant
    end
    
    render :partial => "favorite"
  end
  
  def removeFavorite
    if logged_in?
      @favorite = Favorite.find(params[:id])
      @restaurant = @favorite.restaurant
      @favorite.destroy
      @favorite = nil
    end
    
    render :partial => "favorite"
  end
  
  
end