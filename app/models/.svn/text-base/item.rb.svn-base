class Item < ActiveRecord::Base
  require 'config/constants.rb'
  
  acts_as_versioned
  
  belongs_to :category
  belongs_to :restaurant
  has_many :item_option_groups
  has_many :item_sizes, :conditions => "item_sizes.status_id != #{$DELETED}"
  has_many :item_size_names, :through => :item_sizes
  has_many :option_groups, :through => :item_option_groups, :conditions => "status_id != #{$DELETED}"
  has_many :discount_group_parts

  validates_presence_of      :name
  validates_presence_of      :category_id
  validates_length_of :description, :maximum => 500


  validates_uniqueness_of    :name, :scope => [:restaurant_id, :category_id, :status_id]


  def available?
    self.item_sizes.each do |item_size|
      if item_size.available?
        return true
      end
    end
    
    return false
  end



  def version_updated_at(time)
    versions.find(:first, :conditions => "updated_at <= '#{time}'", :order => "updated_at desc")
  end
end
