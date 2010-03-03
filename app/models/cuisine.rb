class Cuisine < ActiveRecord::Base
  has_many :restaurant_cuisines, :dependent => :destroy
  has_many :restaurants, :through => :restaurant_cuisines
  
  validates_presence_of      :name
  validates_uniqueness_of    :name, :case_sensitive => false


  
  def checked(restaurant_id)
    @restaurantCuisine = RestaurantCuisine.find(:first, :conditions => "restaurant_id = #{restaurant_id} and cuisine_id = #{self.id}")
  
    if @restaurantCuisine
      return "checked"
    else
      return ""
    end
  end

end
