class Option < ActiveRecord::Base
  require 'config/constants.rb'
  
  acts_as_versioned
  
  belongs_to :option_group
  has_many :sub_option_groups
  has_many :option_groups, :through => :sub_option_groups
  has_many :option_sizes, :conditions => "status_id != #{$DELETED}"

  validates_presence_of      :name
  validates_length_of :description, :maximum => 100, :allow_blank => true
  
  validates_uniqueness_of    :name, :scope => [:option_group_id, :status_id]

  def additional_price_for_option(item_size_name_id)
    self.option_sizes.each do |option_size|
      if option_size.item_size_name.id == item_size_name_id
        return option_size.additional_price.to_f
      end
    end
    
    return 0
  end
  
  def additional_price_for_option_versioned(item_size_name_id, time)
    self.option_sizes.each do |option_size|
      if option_size.item_size_name.id == item_size_name_id
        return option_size.version_updated_at(time).additional_price.to_f
      end
    end
    
    return 0
  end

  def version_updated_at(time)
    versions.find(:first, :conditions => "updated_at <= '#{time}'", :order => "updated_at desc")
  end

end
