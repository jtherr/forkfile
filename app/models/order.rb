class Order < ActiveRecord::Base
  include GeoKit::Geocoders  
  acts_as_mappable
  
  belongs_to :restaurant
  belongs_to :user
  belongs_to :state, :foreign_key => :delivery_state_id
  belongs_to :credit_card_type
  has_many :order_items
  has_many :refunds
  
  validates_presence_of :name
  validates_presence_of :phone
  validates_presence_of :email
  validates_presence_of :order_type
  validates_presence_of :payment_type
  
  
  
  validates_numericality_of :delivery_zip, :only_integer => true, :allow_blank => true
  validates_length_of :delivery_zip, :is => 5, :allow_blank => true
  
  validates_format_of :phone, :with => /\A((\(\d{3}\) ?)|(\d{3}[- \.]?))\d{3}[- \.]?\d{4}(\s(x\d+)?){0,1}\Z/i, :allow_blank => true

  validates_numericality_of :credit_card_number, :only_integer => true, :allow_blank => true
  validates_numericality_of :credit_card_code, :only_integer => true, :allow_blank => true
  validates_numericality_of :credit_card_expiration_month, :only_integer => true, :allow_blank => true
  validates_numericality_of :credit_card_expiration_year, :only_integer => true, :allow_blank => true

  validates_uniqueness_of   :order_number, :case_sensitive => true

  validates_length_of       :email,    :within => 3..100, :allow_blank => true
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+.)+[a-z]{2,})\Z/i, :allow_blank => true
  

  before_create :make_order_number
  
  def validate_order(restaurant)
    valid?
    
    if !self.disclaimer_read
      errors.add_to_base("Please click the checkbox next to \"I agree with the disclaimer\"")
    end
    
    validate_order_type(restaurant)
    validate_payment_type?
    
    return errors.empty?
  end
  
  
  def validate_order_type(restaurant)    
    errors.add_on_blank([:delivery_street1, :delivery_city, :delivery_state_id, :delivery_zip]) if self.order_type == "delivery"
    
    if self.order_type == "delivery" && errors.empty?
      location = MultiGeocoder.geocode(self.address)
      if !location.success
        errors.add_to_base("Delivery address is invalid or cannot be located")
      end
      
      if !restaurant.delivery
        errors.add_to_base("This restaurant does not offer delivery")
      elsif location.distance_from(restaurant) > restaurant.delivery_radius
        errors.add_to_base("The address you entered is out of the delivery radius of #{restaurant.delivery_radius} miles for this restaurant")
      end
    end
    
    return errors.empty?
  end
  
  def validate_payment_type?
    errors.add_on_blank([:credit_card_type_id, :credit_card_number, :credit_card_expiration_month, :credit_card_expiration_year, :credit_card_code, :credit_card_first_name,  :credit_card_last_name]) if self.payment_type == "credit_card"
    
    if self.credit_card_type != nil && self.payment_type == "credit_card"
      valid_credit_card_type = false
      self.restaurant.credit_card_types.each do |credit_card_type|
        if credit_card_type.id == self.credit_card_type_id
          valid_credit_card_type = true
          break
        end
      end
      
      if !valid_credit_card_type
        errors.add_to_base("#{self.credit_card_type.name} is not accepted by this restaurant.")
      end
      
      if errors.empty?
        validate_credit_card
      end
    end
    
    return errors.empty?
  end
  
  
  def address
    @value = ""
    if self.delivery_street1 && !self.delivery_street1.empty?
      @value += self.delivery_street1 + ", "
    end
    if self.delivery_street2 && !self.delivery_street2.empty?
      @value += self.delivery_street2 + ", "
    end 
    if self.delivery_city && !self.delivery_city.empty?
      @value += self.delivery_city + ", "
    end
    if self.state
      @value += self.state.abbr + " "
    end
    if self.delivery_zip
      @value += self.delivery_zip
    end
    
    return @value
  end
  
  def validate_credit_card
    creditcard = ActiveMerchant::Billing::CreditCard.new(
        :first_name         => self.credit_card_first_name,
        :last_name          => self.credit_card_last_name,
        :number             => self.credit_card_number,
        :month              => self.credit_card_expiration_month,
        :year               => self.credit_card_expiration_year,
        :verification_value => self.credit_card_code,
        :type               => self.credit_card_type.code
    )
    
    if !creditcard.valid?
      errors.add_to_base("Credit card information is invalid")
    end
  end
  
  protected
    def make_order_number
      self.order_number = generate_random_order_number()
    end
  
    def generate_random_order_number
      generated_order_number = rand(1000000000000)

      if Order.find(:first, :conditions => "order_number = #{generated_order_number}") != nil
        return generate_random_order_number()
      else
        return generated_order_number
      end
    end
  
end
