class RefundNote < ActiveRecord::Base

  belongs_to :user
  belongs_to :refund
  
  validates_presence_of     :refund_id
  validates_presence_of     :notes
  validates_presence_of     :date
  validates_presence_of     :user_id

end
