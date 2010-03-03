class UsersController < ApplicationController
  ssl_required :showProfile, :modifyProfile, :updateProfile, :register, :create, :changePassword, :updatePassword, :changeCreditCard, :updateCreditCard, :ownerAccount, :setPassword
  ssl_allowed :forgotPassword, :sendForgotPasswordEmail
    
  before_filter :admin_required, :only => [ :showUsers, :showProfileAdmin ]
  
  before_filter :session_authentication_required, :only => [ :showProfile, :modifyProfile, :updateProfile ]
  
  before_filter :run_captcha, :only => :create
    
  
  def register
    session[:next_controller] = nil
    session[:next_action] = nil
    
    initRegister()
  end
  
  def orderRegister
    session[:next_controller] = "order"
    session[:next_action] = "enterOrder"

    initRegister()

    render :action => 'register'
  end
  
  def initRegister
    @states = State.find(:all)
    
    @user = User.new()
    
    if session[:order] != nil
      @user.name = session[:order][:name]
      @user.phone = session[:order][:phone]
      @user.email = session[:order][:email]
    end

    if address_stored?
      @user.street1 = current_address[:street1]
      @user.city = current_address[:city]
      @user.state_id = current_address[:state_id]
      @user.zip = current_address[:zip]
    end
    
    @title = "Sign Up"
  end
  
  
  
  def showProfile
    @user = getUser()
    
    @linked_restaurants = @user.owned_restaurants
    
    @title = "My Profile"
  end
  
  
  def showProfileAdmin
    @user = User.find(params[:userId])
    session[:user_profile_id] = @user.id
    
    @linked_restaurants = @user.owned_restaurants
    
    @title = "User Profile"
    render :action => "showProfile"
  end
  
  def modifyProfile
    @states = State.find(:all)
    @user = getUser()
    
    @title = "Modify Profile"
  end
  
  def showUsers
    @users = User.paginate :page => params[:page], :per_page => 10
    
    @title = "Users"
  end
  
  def searchUsers
    @user_search = params[:user_search]
    @users = User.paginate :page => params[:page], :per_page => 10, :conditions => "last_name LIKE '%#{@user_search}%' || email LIKE '%#{@user_search}%'"
    @title = "Users"
    render :action => "showUsers"
  end
  
  
  def create
    if params['commit'] == "Cancel"
      next_controller = session[:next_controller]
      next_action = session[:next_action]
      next_params = session[:next_params]
 
      session[:next_controller] = nil
      session[:next_action] = nil
      session[:next_params] = nil
 
      if (next_controller != nil && next_action != nil)
        redirect_to url_for(:controller => next_controller, :action => next_action, :overwrite_params => next_params)
      else
        redirect_to :controller => "main", :action => "index"
      end
    else
      cookies.delete :auth_token
      # protects against session fixation attacks, wreaks havoc with 
      # request forgery protection.
      # uncomment at your own risk
      # reset_session
      @user = User.new(params[:user])
      
      @user.privilege_id = $CUSTOMER
      
      @location = MultiGeocoder.geocode(@user.address)
      
      @user.lat = @location.lat
      @user.lng = @location.lng
      
      if @user.save
        self.current_user = @user
        
        setCurrentAddressFromCurrentUser()
        
        session[:access_time] = $TIME_ZONE.now
        
        next_controller = session[:next_controller]
        next_action = session[:next_action]
        next_params = session[:next_params]
   
        session[:next_controller] = nil
        session[:next_action] = nil
        session[:next_params] = nil
   
        if (next_controller != nil && next_action != nil)
          redirect_to url_for(:controller => next_controller, :action => next_action, :overwrite_params => next_params)
        else
          redirect_to :controller => "main", :action => "index"
        end
        
      else
        @states = State.find(:all)
        @title = "Sign Up"
        render :action => :register
      end
    end
  end
  
  def updateProfile
    @user = User.find(session[:user_profile_id])
    @user.attributes = params[:user]
    
    @location = MultiGeocoder.geocode(@user.address)
    
    @user.lat = @location.lat
    @user.lng = @location.lng
    
    if @user.save
      redirect_to :action => 'showProfile', :id => @user.id
    else
      @states = State.find(:all)
      render :action => :modifyProfile
    end
    
  end
  
  
  def getUser
    user_id = params[:id] || current_user.id
    
    @user = User.find(user_id)
    session[:user_profile_id] = @user.id
    
    if !admin? && @user != current_user
      #Not allowed to get this user
      redirect_to :controller => 'main', :action => 'index'
    end
    
    return @user
  end
  
  
  def activate
    self.current_user = params[:activation_code].blank? ? false : User.find_by_activation_code(params[:activation_code])
    if logged_in? && !current_user.active?
      current_user.activate
      flash[:notice] = "Signup complete!"
    end
    redirect_back_or_default('/')
  end
  
  
  def forgotPassword
    @title = "Forgot Password"
    render :partial => "forgotPassword"
  end
  
  def sendForgotPasswordEmail
    @email = params[:user][:email]
    @invalid = false
    
    user = User.find_by_email(@email)
  
    @title = "Forgot Password"
    
    if user != nil
      user.forgot_password_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
      
      user.save(false)
      
      UserMailer.deliver_forgotPassword(user)
  
      render :partial => "confirmForgotPasswordEmailSent"
    else
      @invalid = true
      
      render :partial => "forgotPassword", :status => 444
    end
  end
  
  def changePassword
    @forgot_password_code = params[:forgot_password_code]
    @title = "Change Password"
  end
  
  def ownerAccount
    @forgot_password_code = params[:forgot_password_code]
    @title = "Set Your Password"
  end
  
  def updatePassword    
    @forgot_password_code = params[:user][:forgot_password_code]
    @user = @forgot_password_code.blank? ? nil : User.find_by_forgot_password_code(@forgot_password_code)
    
    if @user != nil && @user.update_attributes(params[:user])
      reset_session
      
      self.current_user = @user
    
      @user.forgot_password_code = nil
      @user.save(false)
    
      flash[:notice] = "Password Changed!"

      redirect_to :controller => "main", :action => "index"
    else
      @title = "Change Password"
      
      render :controller => "users", :action => "changePassword"
    end
  end
  
  def setPassword    
    @forgot_password_code = params[:user][:forgot_password_code]
    @user = @forgot_password_code.blank? ? nil : User.find_by_forgot_password_code(@forgot_password_code)
    
    if @user != nil && @user.update_attributes(params[:user])
      reset_session      
      
      self.current_user = @user
    
      @user.forgot_password_code = nil
      @user.save(false)
    
      flash[:notice] = "Your password has been set"

      redirect_to :controller => "main", :action => "index"
    else
      @title = "Set Your Password"
      
      render :controller => "users", :action => "ownerAccount"
    end
  end
  
  
  def changeCreditCard
    @user = current_user

    @months = 1..12
    
    year = Time.now.year
    @years = year..(year+5)
    
    @credit_card_types = CreditCardType.find(:all)
      
    @credit_card_type_id = ""
    @credit_card_number = ""
    @credit_card_expiration_month = ""
    @credit_card_expiration_year = ""
    @credit_card_code = ""
    @credit_card_first_name = ""
    @credit_card_last_name = ""
      
    @title = "My Credit Card"
  end
  
  def updateCreditCard
    if params['commit'] == "Cancel"
      redirect_to :controller => "users", :action => "showProfile", :id => current_user.id

    else
      
      @credit_card_type_id = params[:user][:credit_card_type_id]
      @credit_card_number = params[:user][:credit_card_number]
      @credit_card_expiration_month = params[:user][:credit_card_expiration_month]
      @credit_card_expiration_year = params[:user][:credit_card_expiration_year]
      @credit_card_code = params[:user][:credit_card_code]
      @credit_card_first_name = params[:user][:credit_card_first_name]
      @credit_card_last_name = params[:user][:credit_card_last_name]
      
      current_user.credit_card_type_id = params[:user][:credit_card_type_id]
      current_user.credit_card_number = params[:user][:credit_card_number]
      current_user.credit_card_expiration_month = params[:user][:credit_card_expiration_month]
      current_user.credit_card_expiration_year = params[:user][:credit_card_expiration_year]
      current_user.credit_card_code = params[:user][:credit_card_code]
      current_user.credit_card_first_name = params[:user][:credit_card_first_name]
      current_user.credit_card_last_name = params[:user][:credit_card_last_name]
  
      current_user.validate_credit_card
      
      if current_user.errors.empty?
        current_user.save
        
        redirect_to :controller => "users", :action => "showProfile", :id => current_user.id
      else
        @user = current_user
    
        @months = 1..12
        
        year = Time.now.year
        @years = year..(year+5)
        
        @credit_card_types = CreditCardType.find(:all)
        
      @title = "My Credit Card"
        render :controller => "users", :action => "changeCreditCard"
      end
    end
    
  end
  
  def removeCreditCard
    current_user.credit_card_type_id = nil
    current_user.credit_card_number = nil
    current_user.credit_card_expiration_month = nil
    current_user.credit_card_expiration_year = nil
    current_user.credit_card_code = nil
    current_user.credit_card_first_name = nil
    current_user.credit_card_last_name = nil

    current_user.save
    
    redirect_to :controller => "users", :action => "showProfile", :id => current_user.id
  end


end
