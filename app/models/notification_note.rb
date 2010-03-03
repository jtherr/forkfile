class NotificationNote < ActiveRecord::Base
  belongs_to :user
  belongs_to :notification
  
  validates_presence_of     :notification_id
  validates_presence_of     :notes
  validates_presence_of     :user_id  
  validates_presence_of     :date  

end
