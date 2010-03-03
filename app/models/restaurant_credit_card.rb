class RestaurantCreditCard < ActiveRecord::Base

  belongs_to :restaurant
  belongs_to :credit_card_type

end
