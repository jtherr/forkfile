class OptionSize < ActiveRecord::Base
  acts_as_versioned

  belongs_to :option
  belongs_to :option_version
  belongs_to :item_size_name

  validates_numericality_of :additional_price, :greater_than => 0

  validates_uniqueness_of :item_size_name_id, :scope => [ :option_id ]

  def version_updated_at(time)
    versions.find(:first, :conditions => "updated_at <= '#{time}'", :order => "updated_at desc")
  end
end
