class State < ActiveRecord::Base
  has_many :users
  has_many :restaurants
  has_many :locality_taxes
  has_many :notifications
  has_one :tax
  
end
