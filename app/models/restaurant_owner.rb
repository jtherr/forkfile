class RestaurantOwner < ActiveRecord::Base
  belongs_to :user
  belongs_to :restaurant

  validates_presence_of :user_id, :message => "Could not find owner's email address"
  validates_presence_of :restaurant_id
  
end
