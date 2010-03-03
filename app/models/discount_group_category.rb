class DiscountGroupCategory < ActiveRecord::Base
  belongs_to :discount_group
  belongs_to :category
end