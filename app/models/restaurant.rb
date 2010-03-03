class Restaurant < ActiveRecord::Base
  require 'config/constants.rb'

  include GeoKit::Geocoders  
    
  acts_as_versioned
  acts_as_mappable
    
  belongs_to :state
  belongs_to :credit_card_type
  belongs_to :admin_user, :class_name => "User", :foreign_key => "admin_user_id"
  has_many :items, :conditions => "items.status_id != #{$DELETED}"
  has_many :restaurant_cuisines
  has_many :cuisines, :through => :restaurant_cuisines, :order => "name"
  has_many :delivery_zip_codes
  has_many :favorites
  has_many :restaurant_owners
  has_many :owners, :through => :restaurant_owners, :source => :user
  has_many :categories
  has_many :restaurant_hours, :order => "sunday DESC, monday DESC, tuesday DESC, wednesday DESC, thursday DESC, friday DESC, saturday DESC, start_hour, start_minute"
  has_many :delivery_hours
  has_many :take_out_hours
  has_many :restaurant_hour_exceptions
  has_many :refunds
  has_many :orders
  has_many :option_groups, :conditions => "status_id != #{$DELETED}"
  has_many :item_size_names
  has_many :restaurant_credit_cards
  has_many :credit_card_types, :through => :restaurant_credit_cards
  has_many :item_sizes, :through => :items
  has_many :discounts
  has_many :discount_groups
  has_many :restaurant_emails
  has_one :logo, :dependent => :destroy
  
  
  validates_presence_of     :name
  validates_presence_of     :street1
  validates_presence_of     :city
  validates_presence_of     :state_id
  validates_presence_of     :zip
  validates_presence_of     :phone1
  validates_presence_of     :fax, :if => :fax_enabled
  validates_presence_of     :credit_card_minimum
  validates_inclusion_of    :fax_enabled, :in => [true, false]
  validates_inclusion_of    :delivery, :in => [true, false]
  validates_inclusion_of    :take_out, :in => [true, false]
  validates_inclusion_of    :dine_in, :in => [true, false]
  validates_presence_of     :delivery_charge, :if => :delivery
  validates_presence_of     :delivery_percent, :if => :delivery
  validates_presence_of     :delivery_radius, :if => :delivery
  validates_presence_of     :delivery_minimum, :if => :delivery
  validates_presence_of     :delivery_time, :if => :delivery
  validates_presence_of     :take_out_time, :if => :take_out
  
  validates_numericality_of :phone1
  validates_numericality_of :phone2, :allow_blank => true
  validates_numericality_of :fax, :allow_blank => true

  validates_length_of :phone1, :is => 10
  validates_length_of :phone2, :is => 10, :allow_blank => true
  validates_length_of :fax, :is => 10, :allow_blank => true
  
  validates_numericality_of :delivery_radius, :greater_than => 0, :if => :delivery
  validates_numericality_of :delivery_charge, :if => :delivery
  validates_numericality_of :delivery_percent, :if => :delivery
  validates_numericality_of :delivery_minimum, :if => :delivery
  validates_numericality_of :delivery_time, :greater_than => 0, :only_integer => true, :if => :delivery
  validates_numericality_of :take_out_time, :greater_than => 0, :only_integer => true, :if => :take_out
  
  validates_numericality_of :credit_card_minimum
  
  validates_uniqueness_of   :account_number, :case_sensitive => true
  
  validates_uniqueness_of   :name, :case_sensitive => false, :scope => [:street1, :city, :state_id, :zip, :status_id]
  
  validates_length_of :notes, :maximum => 250, :allow_blank => true
  
  before_create :make_account_number
  
  
  def validate
    location = MultiGeocoder.geocode(self.address)
    if !location.success
      errors.add_to_base("Address is invalid or cannot be located")
    end
    
    if !self.delivery && !self.take_out
      errors.add_to_base("Must select delivery and/or take out")
    end
    
  end
  
  
  def activation_allowed?
    if (self.restaurant_cuisines.empty? ||
      self.categories.empty? ||
      self.restaurant_hours.empty? ||
      self.credit_card_types.empty? ||
      self.items.empty? ||
      !self.contract_signed ||
      (!self.fax_enabled && self.restaurant_emails.empty?))
      
      return false
    end
    
    return true
  end
  
  
  
  def address
    value = ""
    if !self.street1.empty?
      value += self.street1 + ", "
    end
    if !self.street2.empty?
      value += self.street2 + ", "
    end 
    if !self.city.empty?
      value += self.city + ", "
    end
    if self.state
      value += self.state.abbr + " "
    end
    if self.zip
      value += self.zip
    end
    
    return value
  end
  
  def address_formatted
    value = ""
    if !self.street1.empty?
      value += self.street1 + "<br />"
    end
    if !self.street2.empty?
      value += self.street2 + "<br />"
    end 
    if !self.city.empty?
      value += self.city + ", "
    end
    if self.state
      value += self.state.abbr + " "
    end
    if self.zip
      value += self.zip
    end
    
    return value
  end
  
  
  def delivery_selected?
    self.delivery
  end
  
  def favorite(current_user)
    Favorite.find(:first, :conditions => "user_id = #{current_user.id} and restaurant_id = #{self.id}")
  end
  
  def isOpen
    now = $TIME_ZONE.now
    
    exceptionYesterdayClosed = false
    
    self.restaurant_hour_exceptions.each do |hour_exception|
      exceptionClosed = hour_exception.closed
      
      if hour_exception.match(now)
        if exceptionClosed
          return false
        else
          return true
        end
      elsif hour_exception.matchDate(now - 1.day) && exceptionClosed
        exceptionYesterdayClosed = true
      end
    end
        
    self.restaurant_hours.each do |hour|
      if hour.isTimeWithin(now, exceptionYesterdayClosed)
        return true
      end
    end
    
    return false
  end
  
  def isDeliveryAvailable
    now = $TIME_ZONE.now
        
    if self.delivery_hours.empty?
      return true
    end
        
    self.delivery_hours.each do |hour|
      if hour.isTimeWithin(now)
        return true
      end
    end
    
    return false
  end
  

  def isTakeOutAvailable
    now = $TIME_ZONE.now
        
    if self.take_out_hours.empty?
      return true
    end
    
    self.take_out_hours.each do |hour|
      if hour.isTimeWithin(now)
        return true
      end
    end
    
    return false
  end
  
  
  def current_specials
    specials = []
        
    self.all_specials.each do |special_hour|      
      if special_hour.isTimeWithin($TIME_ZONE.now)
        specials.push(special_hour)
      end
    end
    
    return specials
  end
  
  def specials_on_day(day_id)    
    day_condition = ""
    case day_id
    when 0
      day_condition = "sunday = true"
    when 1
      day_condition = "monday = true"
    when 2
      day_condition = "tuesday = true"
    when 3
      day_condition = "wednesday = true"
    when 4
      day_condition = "thursday = true"
    when 5
      day_condition = "friday = true"
    when 6
      day_condition = "saturday = true"
    end    
    
    special_hours = SpecialHour.find(:all, :include => [ :item_size => { :item => :restaurant } ], :conditions => "restaurants.id = #{self.id} AND item_sizes.status_id = #{$ACTIVE} AND items.status_id = #{$ACTIVE} AND #{day_condition}")
    
    return special_hours
  end
  
  
  def all_specials    
    return SpecialHour.find(:all, :include => [ :item_size => { :item => :restaurant } ], :conditions => "restaurants.id = #{self.id} AND item_sizes.status_id = #{$ACTIVE} AND items.status_id = #{$ACTIVE}")
  end
  
  
  def has_specials
    special_hour = SpecialHour.find(:first, :include => [ :item_size => { :item => :restaurant } ], :conditions => "restaurants.id = #{self.id} AND item_sizes.status_id = #{$ACTIVE} AND items.status_id = #{$ACTIVE}")
    if special_hour == nil
      return false
    end
    return true
  end
  
  
  def current_discounts
    discounts_list = []
    
    self.discounts.each do |discount|      
      if discount.available?
        discounts_list.push(discount)
      end
    end
    
    return discounts_list
  end
  
  def discounts_on_day(day_id)
    discounts_list = []
    
    day_condition = ""
    case day_id
    when 0
      day_condition = "sunday = true"
    when 1
      day_condition = "monday = true"
    when 2
      day_condition = "tuesday = true"
    when 3
      day_condition = "wednesday = true"
    when 4
      day_condition = "thursday = true"
    when 5
      day_condition = "friday = true"
    when 6
      day_condition = "saturday = true"
    end    
    
    self.discounts.each do |discount|
      if discount.discount_hours.empty?
        discounts_list.push(discount)
      elsif !discount.discount_hours.find(:all, :conditions => day_condition).empty?
        discounts_list.push(discount)
      end
    end
    
    return discounts_list
  end
  
  
  def website_url
    if self.website != nil && (self.website[0..6] !=  "http://" && self.website[0..7] !=  "https://")
      return "http://" + self.website
    end
    
    return self.website
  end
  
  
  def validate_credit_card
    errors.add_on_blank([:credit_card_type_id, :credit_card_number, :credit_card_expiration_month, :credit_card_expiration_year, :credit_card_code, :credit_card_first_name,  :credit_card_last_name])
    
    if errors.empty? && !self.credit_card_valid?
      errors.add_to_base("Credit card information is invalid")
    end
  end
  
  
  def credit_card_valid?
    if self.credit_card_type_id == nil
      return false
    end
    
    creditcard = ActiveMerchant::Billing::CreditCard.new(
       :first_name         => self.credit_card_first_name,
       :last_name          => self.credit_card_last_name,
       :number             => self.credit_card_number,
       :month              => self.credit_card_expiration_month,
       :year               => self.credit_card_expiration_year,
       :verification_value => self.credit_card_code,
       :type               => self.credit_card_type.code
    )
    
    return creditcard.valid?
  end
  
  
  def logo_filename
    if self.logo != nil
      return "/images/restaurant_logos/" + self.logo.filename
    else
      return "/images/noLogo.gif"
    end
  end
  
  
  def version_updated_at(time)
    versions.find(:first, :conditions => "updated_at <= '#{time}'", :order => "updated_at desc")
  end
  
  def active?
    return self.status_id == $ACTIVE
  end
  
  
  def getProperties()
    properties = []
    
    if self.delivery
      properties.push("Delivery")
    end
    if self.take_out
      properties.push("Take Out")
    end
    if self.has_specials || !self.discounts.empty?
      properties.push("Specials")
    end
    
    return properties
  end
  
  
  protected
  def make_account_number
    self.account_number = generate_random_account_number()
  end
  
  def generate_random_account_number
    generated_account_number = rand(100000000)

    if Restaurant.find(:first, :conditions => "account_number = #{generated_account_number}") != nil
      return generate_random_account_number()
    else
      return generated_account_number
    end
  end
  
  
end
