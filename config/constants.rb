
$CUSTOMER = 1
$OWNER = 2
$ADMIN = 3
$SUPER_ADMIN = 4

$USER_PRIVILEGES = {
  $CUSTOMER => { :name => "Customer" },
  $OWNER => { :name => "Owner" },
  $ADMIN => { :name => "Admin" },
  $SUPER_ADMIN => { :name => "Super Admin" }  
}


$ACTIVE = 1
$INACTIVE = 2
$DELETED = 3
$PENDING_APPROVAL = 4  

$DB_STATUSES = {
  $ACTIVE => { :name => "Active" },
  $INACTIVE => { :name => "Inactive" },
  $DELETED => { :name => "Deleted" },
  $PENDING_APPROVAL => { :name => "Pending Approval" }
}

$CHANGE_ITEM_STATUS = 1
$LINK_OPTION_GROUP = 2

$ITEM_ACTIONS = {
  $CHANGE_ITEM_STATUS => { :name => "Change Status" },
  $LINK_OPTION_GROUP => { :name => "Link Option Group" }
}


$WEEKDAYS = {
  0 => {:name => "Sunday", :abbr => "Sun", :letter => "S" },
  1 => {:name => "Monday", :abbr => "Mon", :letter => "M" },
  2 => {:name => "Tuesday", :abbr => "Tues", :letter => "T" },
  3 => {:name => "Wednesday", :abbr => "Wed", :letter => "W" },
  4 => {:name => "Thursday", :abbr => "Thurs", :letter => "T" },
  5 => {:name => "Friday", :abbr => "Fri", :letter => "F" },
  6 => {:name => "Saturday", :abbr => "Sat", :letter => "S" }
}

$NOTIFICATION_STATUSES = {
  0 => { :name => "Open", :active => true },
  1 => { :name => "Resolved", :active => false }  
}

$REFUND_STATUSES = {
  0 => { :name => "Open", :active => true, :dropdown => true },
  1 => { :name => "Granted (not yet paid)", :active => false, :dropdown => true }, 
  2 => { :name => "Rejected", :active => false, :dropdown => true }, 
  3 => { :name => "Paid", :active => false, :dropdown => false }  
}

$ONCE = 0
$DAILY = 1
$WEEKLY = 2
$MONTHLY_DAY_OF_WEEK = 3
$MONTHLY_DAY_OF_MONTH = 4
$YEARLY = 5

$RECURRING_DATE_TYPES = {
  $ONCE => { :name => "Once" },
  $DAILY => { :name => "Daily" }, 
  $WEEKLY => { :name => "Weekly" }, 
  $MONTHLY_DAY_OF_WEEK => { :name => "Monthly - Day of Week" }, 
  $MONTHLY_DAY_OF_MONTH => { :name => "Monthly - Day of Month" }, 
  $YEARLY => { :name => "Yearly" }  
}

$TEST_FAX_NUMBER = '7032371351'
$TEST_PHONE_NUMBER = '8148838332'

$DEFAULT_SEARCH_DISTANCE = 10
$DEFAULT_ITEMS_PER_PAGE = 20


# Twilio Variables
$TWILIO_API_VERSION = '2008-08-01'
$TWILIO_ACCOUNT_SID = 'ACd250f2f574a35a17e9e527bf56af61aa'
$TWILIO_ACCOUNT_TOKEN = '3f715c3f199fe0e4ae842049ac9d36e6'

