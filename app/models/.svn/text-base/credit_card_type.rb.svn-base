class CreditCardType < ActiveRecord::Base
  has_many :orders
  has_many :users
  has_many :restaurants
  has_many :restaurant_credit_cards


  def checked(restaurant_id)
    restaurantCreditCard = self.restaurant_credit_cards.find(:first, :conditions => "restaurant_id = #{restaurant_id}")
      
    if restaurantCreditCard
      return "checked"
    else
      return ""
    end
  end

end
