require 'digest/sha1'
class User < ActiveRecord::Base
  require 'config/constants.rb'
  
  include GeoKit::Geocoders  
  acts_as_mappable
  
  belongs_to :state
  belongs_to :credit_card_type
  has_many :favorites
  has_many :favorite_restaurants, :through => :favorites, :source => :restaurant, :conditions => "status_id = #{$ACTIVE}"
  has_many :restaurant_owners
  has_many :owned_restaurants, :through => :restaurant_owners, :source => :restaurant, :conditions => "status_id = #{$ACTIVE}"
  has_many :orders
  has_many :notifications
  has_many :notification_notes
  has_many :refunds
  has_many :refund_notes
  has_many :admin_restaurants, :source => :restaurant
  
  # Virtual attribute for the unencrypted password
  attr_accessor :password

  validates_presence_of     :name

  validates_presence_of     :email
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 8..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :email,    :within => 3..100, :allow_blank => true
  validates_uniqueness_of   :email, :case_sensitive => true
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+.)+[a-z]{2,})\Z/i
  
  validates_format_of :phone, :with => /\A((\(\d{3}\) ?)|(\d{3}[- \.]?))\d{3}[- \.]?\d{4}(\s(x\d+)?){0,1}\Z/i, :allow_blank => true
  
  
  before_save :encrypt_password
  before_create :make_activation_code 

  
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :email, :password, :password_confirmation, :name,
  :phone, :street1, :street2, :city, :state_id, :zip, :privilege_id
  
  def validate
    @location = MultiGeocoder.geocode(self.address)
    if !@location.success
      errors.add_to_base("Address is invalid or cannot be located")
    end
    
    if self.zip.empty? && (self.city.empty? || !self.state_id)
      errors.add_to_base("Must provide either 'city and state' OR 'zip code'")
    end
  end
  
  
  def address
    @value = ""
    if self.street1 && !self.street1.empty?
      @value += self.street1 + ", "
    end
    if self.city && !self.city.empty?
      @value += self.city + ", "
    end
    if self.state
      @value += self.state.abbr + " "
    end
    if self.zip
      @value += self.zip
    end
    
    return @value
  end
  
  def full_name
    return self.name
  end
  
  
  
  # Activates the user in the database.
  def activate
    @activated = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
    save(false)
  end

  def active?
    # the existence of an activation code means they have not activated yet
    activation_code.nil?
  end
  
  
  
  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(email, password)
    # u = find :first, :conditions => ['email = ? and activated_at IS NOT NULL', email] # need to get the salt
    
    u = find :first, :conditions => ['email = ?', email] # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end
  
  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end
  
  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end
  
  def authenticated?(password)
    crypted_password == encrypt(password)
  end
  
  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end
  
  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 1.month
  end
  
  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end
  
  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end
  
  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end
  
  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end
  
  def credit_card_valid?
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
  
  def validate_credit_card
    errors.add_on_blank([:credit_card_type_id, :credit_card_number, :credit_card_expiration_month, :credit_card_expiration_year, :credit_card_code, :credit_card_first_name,  :credit_card_last_name])
    
    if errors.empty? && !self.credit_card_valid?
      errors.add_to_base("Credit card information is invalid")
    end
  end
  
  
  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{email}--") if new_record?
      self.crypted_password = encrypt(password)
    end
    
    def password_required?
      crypted_password.blank? || !password.blank?
    end
    
    def make_activation_code
      self.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    end
  
  
end
