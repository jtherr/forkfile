class Notification < ActiveRecord::Base
  belongs_to :notification_reason
  belongs_to :user
  belongs_to :state
  has_many :notification_notes
  
  validates_presence_of     :notification_reason_id
  validates_presence_of     :message, :unless => :restaurant_name
  validates_presence_of     :email  
  validates_presence_of     :date  
  
  validates_presence_of     :restaurant_name, :if => :restaurant_name
  validates_presence_of     :name, :if => :restaurant_name
  validates_presence_of     :phone, :if => :restaurant_name

  validates_format_of :phone, :with => /\A((\(\d{3}\) ?)|(\d{3}[- \.]?))\d{3}[- \.]?\d{4}(\s(x\d+)?){0,1}\Z/i, :allow_blank => true

  validates_length_of :message, :maximum => 500
  validates_length_of :order_number, :maximum => 14, :allow_blank => true
  
  validates_numericality_of :order_number, :greater_than => 0, :only_integer => true, :allow_blank => true

end
