class OrderController < ApplicationController
  include Phone

  ssl_required :enterOrder, :submitOrder, :selectOrderType, :selectPaymentType, :reviewOrder, :confirmOrder, :updateOrderType, :updatePaymentType, :register, :createSession, :createUser
  
  before_filter :run_captcha, :only => [ :createUser, :confirmOrder, :submitOrder ]
  before_filter :check_for_order, :only => [ :enterOrder, :submitOrder, :selectOrderType, :selectPaymentType, :reviewOrder, :confirmOrder, :editItem, :updateExisting, :remove, :updateOrderType, :updatePaymentType, :register ]
  before_filter :check_for_order_items, :only => [ :enterOrder, :submitOrder, :register, :selectOrderType, :selectPaymentType, :reviewOrder, :confirmOrder ]
  before_filter :check_for_restaurant, :only => [ :selectDiscount, :updateCart, :updateExisting, :addPreviousOrder, :sendTestFax ]
  before_filter :check_for_address
  before_filter :check_if_cart_expired, :only => [ :enterOrder, :submitOrder, :register, :selectOrderType, :selectPaymentType, :reviewOrder, :confirmOrder, :updateOrderType, :updatePaymentType ]
  before_filter :session_authentication_required_if_logged_in, :only => [ :enterOrder, :submitOrder ]

  def check_for_order
    if session[:order] == nil
      session_expired()
    end
  end
  
  def check_for_order_items
    if session[:order] == nil || session[:order][:items] == nil || session[:order][:items].empty?
      session_expired()
    end
  end
  
  
  def checkoutOptions
    session[:next_controller] = "order"
    session[:next_action] = "checkout"
    
    @title = "To checkout, select from the following options"
    
    render :partial => "checkoutOptions"
  end
  
  def selectOptions
    @item = Item.find(params[:id])
    session[:selected_item_id] = params[:id]
    
    @restaurant = @item.restaurant
    @item_sizes = @item.item_sizes
    @option_groups = @item.option_groups
    
    @category_available = @item.category.available?
        
    @item_sizes_available = 0
        
    if @item_sizes.length == 1 && @item_sizes[0].available? && @item_sizes[0].item_size_name.available? && @category_available
      @item_size = @item_sizes[0]
      @item_sizes_available = 1
    else
      @item_sizes.each do |item_size|
        if item_size.available? && item_size.item_size_name.available? && @category_available
          @item_sizes_available += 1
          @item_size = item_size
          
          if @item_sizes_available > 1
            @item_size = nil
            break
          end
        end
      end
    end
        
    @form_action = "updateCart"
        
    session[:selected_order_item] = nil
    
    @title = @restaurant.name + " - " + @item.name
    
    render :partial => 'selectOptions'
  end
  
  
  def updateItemSize
    @item_size = ItemSize.find(params[:id])
    @item = @item_size.item
    @option_groups = @item.option_groups
    
    if session[:selected_order_item] != nil
      @form_action = "updateExisting"
    else
      @form_action = "updateCart"
    end
        
    render :partial => 'options'
  end

  
  def selectDiscount
    @restaurant = current_restaurant
    @discount = Discount.find(params[:id])
    
    @title = @restaurant.name + " - " + @discount.name
    
    render :partial => "selectDiscount"
  end
  

  def register
    @states = State.find(:all)
    @title = "Register"
  end
  
  
  def checkout
    rate()
    redirect_to :action => "enterOrder"
  end
  
  
  def enterOrder
    @restaurant = Restaurant.find(session[:order][:restaurant_id])
    @user = current_user
    
    @order = Order.new()
    
    @order.order_type = session[:order][:order_type]
    
    if logged_in?
      @order.name = @user.name
      @order.phone = @user.phone
      
      @order.delivery_street1 = @user.street1
      @order.delivery_street2 = @user.street2
      @order.delivery_city = @user.city
      @order.delivery_state_id = @user.state_id
      @order.delivery_zip = @user.zip
    
      if @user.credit_card_type_id != nil
        @existing_credit_card_type = @user.credit_card_type
        @existing_credit_card_number = @user.credit_card_number
        @existing_credit_card_expiration_month = @user.credit_card_expiration_month
        @existing_credit_card_expiration_year = @user.credit_card_expiration_year
      end
      
    else
      @order.delivery_street1 = current_address[:street1]
      @order.delivery_street2 = current_address[:street2]
      @order.delivery_city = current_address[:city]
      @order.delivery_state_id = current_address[:state_id]
      @order.delivery_zip = current_address[:zip]
    end
    
    if @order.delivery_state_id
      @delivery_state = State.find(@order.delivery_state_id)
    end
  
    @contact_info_entered = @order.name != nil && !@order.name.empty? &&
        @order.phone != nil && !@order.phone.empty?
    
    @delivery_address_entered = @order.delivery_street1 != nil && !@order.delivery_street1.empty? &&
        @order.delivery_city != nil && !@order.delivery_city.empty? &&
        @order.delivery_state_id != nil &&
        @order.delivery_zip != nil && !@order.delivery_zip.empty?
        
    @credit_card_info_entered = @existing_credit_card_type != nil
    
    @credit_card_types = @restaurant.credit_card_types
    
    @months = 1..12
    
    year = Time.now.year
    @years = year..(year+5)    
    
    @states = State.find(:all)
    @title = "Checkout"
  end
  
  
  def submitOrder
    orderSession = session[:order]
    @user = current_user
    
    @order = Order.new(params[:order])
    
    @order.restaurant_id = orderSession[:restaurant_id]
    
    if logged_in?
      @order.user_id = current_user.id
      @order.email = current_user.email
    end
    
    @order.discount = orderSession[:discount]
    @order.sub_total = orderSession[:sub_total]
    @order.delivery_charge = orderSession[:delivery_charge]
    @order.tax = orderSession[:tax]
    @order.total_price = orderSession[:total_price]
    @order.order_time = Time.now
    
    @contact_info_entered = params[:contact_info_entered] == "true"
    @delivery_address_entered = params[:delivery_address_entered] == "true"
    @credit_card_info_entered = params[:credit_card_info_entered] == "true"
    
    if logged_in? && @contact_info_entered
      @order.phone = @user.phone
      @order.name = @user.name
      @order.email = @user.email
    end
            
    if @order.order_type == "delivery"
      if @delivery_address_entered
        @order.delivery_street1 = current_address[:street1]
        @order.delivery_street2 = current_address[:street2]
        @order.delivery_city = current_address[:city]
        @order.delivery_state_id = current_address[:state_id]
        @order.delivery_zip = current_address[:zip]
      end
    end
        
    if @order.payment_type == "credit_card"
      if logged_in? && @credit_card_info_entered
        @order.credit_card_type_id = @user.credit_card_type_id
        @order.credit_card_number = @user.credit_card_number
        @order.credit_card_expiration_month = @user.credit_card_expiration_month
        @order.credit_card_expiration_year = @user.credit_card_expiration_year
        @order.credit_card_code = @user.credit_card_code
        @order.credit_card_first_name = @user.credit_card_first_name
        @order.credit_card_last_name = @user.credit_card_last_name

        @existing_credit_card_type = @user.credit_card_type
        @existing_credit_card_number = @user.credit_card_number
        @existing_credit_card_expiration_month = @user.credit_card_expiration_month
        @existing_credit_card_expiration_year = @user.credit_card_expiration_year
      end
    end
    
    
    orderSession[:items].each do |item|
      item_size_id = item[:item_size_id]
      
      order_item = @order.order_items.build(:item_size_id => item_size_id, :quantity => item[:quantity], :special_instructions => item[:special_instructions], :price => item[:price])
      
      option_groups = item[:option_groups]
      if option_groups
        option_groups.each do |option_group_id, selected_options|          
          selected_options.each do |selected_option|
            order_item.order_item_options.build(:option_id => selected_option[:option_id], :quantity => selected_option[:quantity])
          end
        end
      end
    end
    
    
    @order.status = "submitted"
    
    @restaurant = Restaurant.find(orderSession[:restaurant_id])
        
    if @order.validate_order(@restaurant) && @order.save
      @title = "Confirmation"
      
      if @restaurant.fax_enabled
        faxOrder(@order)
      end
            
      UserMailer.deliver_order_confirmation(@order)
      
      @restaurant.restaurant_emails.each do |restaurant_email|
        UserMailer.deliver_restaurant_order(@order, restaurant_email.email)
      end
      
      if ENV['RAILS_ENV'] == 'production' || @restaurant.phone1 == $TEST_PHONE_NUMBER
        callRestaurant(@order)
      end
      
      redirect_to :action => "showConfirmation", :id => @order.id
    else
 
      if @order.delivery_state_id
        @delivery_state = State.find(@order.delivery_state_id)
      end
      
      if logged_in? && @credit_card_info_entered
        @order.credit_card_type_id = nil
        @order.credit_card_number = nil
        @order.credit_card_expiration_month = nil
        @order.credit_card_expiration_year = nil
        @order.credit_card_code = nil
        @order.credit_card_first_name = nil
        @order.credit_card_last_name = nil
        
        @existing_credit_card_type = @user.credit_card_type
        @existing_credit_card_number = @user.credit_card_number
        @existing_credit_card_expiration_month = @user.credit_card_expiration_month
        @existing_credit_card_expiration_year = @user.credit_card_expiration_year
      end
      
      @credit_card_types = @restaurant.credit_card_types
      
      @months = 1..12
      
      year = Time.now.year
      @years = year..(year+5)    
      
      @states = State.find(:all)
      
      @title = "Checkout"
      render :action => "enterOrder"
    end  
  end
  
  
  
  
  
  
  def selectOrderType    
    @user = current_user
    
    @restaurant = Restaurant.find(session[:order][:restaurant_id])
    
    if logged_in?
      if session[:order][:name] == nil
        session[:order][:name] = @user.name
      end
      
      if session[:order][:phone] == nil
        session[:order][:phone] = @user.phone
      end
      
      if session[:order][:delivery_street1] == nil
        session[:order][:delivery_street1] = @user.street1
        session[:order][:delivery_street2] = @user.street2
        session[:order][:delivery_city] = @user.city
        session[:order][:delivery_state_id] = @user.state_id
        session[:order][:delivery_zip] = @user.zip
      end
    else
      if session[:order][:delivery_street1] == nil
        session[:order][:delivery_street1] = current_address[:street1]
        session[:order][:delivery_street2] = current_address[:street2]
        session[:order][:delivery_city] = current_address[:city]
        session[:order][:delivery_state_id] = current_address[:state_id]
        session[:order][:delivery_zip] = current_address[:zip]
      end
    end
    
    @states = State.find(:all)
    @title = "Order Type"
    
    if !@restaurant.isOpen
      redirect_to :controller => "restaurant", :action => "showRestaurant", :id => @restaurant.id
    end
  end
  
  def selectPaymentType
    @user = current_user
    
    if logged_in?
      if session[:order][:payment_type] == nil
        session[:order][:new_credit_card_type_id] = nil
        session[:order][:new_credit_card_number] = nil
        session[:order][:new_credit_card_expiration_month] = nil
        session[:order][:new_credit_card_expiration_year] = nil
        session[:order][:new_credit_card_code] = nil
        session[:order][:new_credit_card_first_name] = nil
        session[:order][:new_credit_card_last_name] = nil
      end
      
      @credit_card_on_file = @user.credit_card_type_id != nil
    end
    
    @restaurant = Restaurant.find(session[:order][:restaurant_id])
    
    @credit_card_types = @restaurant.credit_card_types
    
    @months = 1..12
    
    year = Time.now.year
    @years = year..(year+5)
    
    @credit_card_selection = "saved"
    
    @title = "Payment Type"
    
    
    if !@restaurant.isOpen
      redirect_to :controller => "restaurant", :action => "showRestaurant", :id => @restaurant.id
    end
  end
  
  def reviewOrder
    if session[:order][:order_type] == "delivery" && session[:order][:delivery_state_id]
      @delivery_state = State.find(session[:order][:delivery_state_id])
    end
    
    if session[:order][:payment_type] == "credit_card" && session[:order][:credit_card_type_id]
      @credit_card_type = CreditCardType.find(session[:order][:credit_card_type_id])
    end
    
    @title = "Review Order"
  end
  
  def confirmOrder
    orderSession = session[:order]
    
    @order = Order.new
    @order.restaurant_id = orderSession[:restaurant_id]
    
    if logged_in?
      @order.user_id = current_user.id
    end
    
    @order.discount = orderSession[:discount]
    @order.sub_total = orderSession[:sub_total]
    @order.delivery_charge = orderSession[:delivery_charge]
    @order.tax = orderSession[:tax]
    @order.total_price = orderSession[:total_price]
    @order.order_time = Time.now
    @order.phone = orderSession[:phone]
    
    @order.name = orderSession[:name]
    @order.email = orderSession[:email]
    
    @order.order_type = orderSession[:order_type]
    
    if orderSession[:order_type] == "delivery"
      @order.delivery_street1 = orderSession[:delivery_street1]
      @order.delivery_street2 = orderSession[:delivery_street2]
      @order.delivery_city = orderSession[:delivery_city]
      @order.delivery_state_id = orderSession[:delivery_state_id]
      @order.delivery_zip = orderSession[:delivery_zip]
    end
    
    @order.payment_type = orderSession[:payment_type]
    
    if orderSession[:payment_type] == "credit_card"
      @order.credit_card_type_id = orderSession[:credit_card_type_id]
      @order.credit_card_number = orderSession[:credit_card_number]
      @order.credit_card_expiration_month = orderSession[:credit_card_expiration_month]
      @order.credit_card_expiration_year = orderSession[:credit_card_expiration_year]
      @order.credit_card_code = orderSession[:credit_card_code]
      @order.credit_card_first_name = orderSession[:credit_card_first_name]
      @order.credit_card_last_name = orderSession[:credit_card_last_name]
    end
    
    
    orderSession[:items].each do |item|
      item_size_id = item[:item_size_id]
      
      order_item = @order.order_items.build(:item_size_id => item_size_id, :quantity => item[:quantity], :special_instructions => item[:special_instructions], :price => item[:price])
      
      option_groups = item[:option_groups]
      if option_groups
        option_groups.each do |option_group_id, selected_options|          
          selected_options.each do |selected_option|
            order_item.order_item_options.build(:option_id => selected_option[:option_id], :quantity => selected_option[:quantity])
          end
        end
      end
    end
    
    
    @order.status = "submitted"
    @order.disclaimer_read = params[:order][:disclaimer_read]
    
    @restaurant = Restaurant.find(orderSession[:restaurant_id])
        
    if @order.validate_order(@restaurant) && @order.save
      @title = "Confirmation"
      
      if @restaurant.fax_enabled
        faxOrder(@order)
      end
            
      UserMailer.deliver_order_confirmation(@order)
      
      @restaurant.restaurant_emails.each do |restaurant_email|
        UserMailer.deliver_restaurant_order(@order, restaurant_email.email)
      end
      
      if ENV['RAILS_ENV'] == 'production' || @order.phone == $TEST_PHONE_NUMBER
        callRestaurant(@order)
      end
      
      redirect_to :action => "showConfirmation", :id => @order.id
    else
 
      if session[:order][:delivery_state_id]
        @delivery_state = State.find(session[:order][:delivery_state_id])
      end
      
      if session[:order][:credit_card_type_id]
        @credit_card_type = CreditCardType.find(session[:order][:credit_card_type_id])
      end
      
      @title = "Review Order"
      render :action => "reviewOrder"
    end
    
  end
  
  
  def showConfirmation
    @order = Order.find(params[:id])
    @title = "Confirmation"
    
    render :action => "showConfirmation"
    session[:order] = nil
  end
  
  
  def editItem
    items = session[:order][:items]
    
    item_array_id = params[:id].to_i
    
    session[:selected_order_item] = item_array_id
    
    item = items[item_array_id]

    @all_selected_options = []

    item[:option_groups].each do |option_group_id, options|
      options.each do |option|
        @all_selected_options.push(option)
      end
    end
    
    @item_size = ItemSize.find(item[:item_size_id])
    @item = @item_size.item
    
    session[:selected_item_id] = @item.id

    @option_groups = @item.option_groups
    
    @item_sizes = @item.item_sizes
    
    
    @category_available = @item.category.available?
    
    @item_sizes_available = 0
        
    if @item_sizes.length == 1 && @item_sizes[0].available? && @item_sizes[0].item_size_name.available? && @category_available
      @item_sizes_available = 1
    else
      @item_sizes.each do |item_size|
        if item_size.available? && item_size.item_size_name.available? && @category_available
          @item_sizes_available += 1
          
          if @item_sizes_available > 1
            break
          end
        end
      end
    end
          
    
    @restaurant = @item.restaurant
    @category_available = @item.category.available?
    
    @quantity = item[:quantity]
    @special_instructions = item[:special_instructions]

    @form_action = "updateExisting"
    
    @title = @restaurant.name + " - " + @item.name

    render :partial => "selectOptions"
  end
  
  
  def viewCurrentOrder
    @title = "My Order"
  end
  
  
  def viewPreviousOrder
    @order = Order.find(params[:id])
    
    if current_user.id != @order.user_id
      redirect_to :controller => "main", :action => "portal"
    end
    
    @title = "Previous Order"
  end

  def showRecentOrders
    @orders = current_user.orders.paginate :page => params[:page], :per_page => 20, :order => "order_time desc"
    @title = "Past Orders"
  end
  
  def updateCart
    @order = session[:order]
    
    if @order == nil
      @order = initOrder()
    else
      if current_restaurant.id.to_i != @order[:restaurant_id].to_i        
        @order = initOrder()
      end
    end
 
    @quantity = params[:order_item][:quantity]
    @special_instructions = params[:order_item][:special_instructions]
    
    item_size_id = params[:order_item][:size]
    
    if item_size_id == nil
      @item_size_error = true
    else
      @item_size_error = false
    
      option_group_selections = {}
      
      option_groups_params = params[:option]

      @option_groups_in_error = checkOptionGroups(item_size_id, option_groups_params)
      @all_selected_options = []
      
      if option_groups_params
        option_groups_params.each do |option_group_id, options|
          selected_options = []
          
          option_group = OptionGroup.find(option_group_id)
          
          total_selected_options = 0
          
          if !option_group.min_selected || option_group.min_selected == 0 || !option_group.max_selected || option_group.max_selected > 1
            options.each do |option_id, selected|
              if options[option_id][:selected] == '1'
                
                option = Option.find(option_id)
                
                selected_option = {}
                
                selected_option[:option_id] = option_id
                
                if option.allow_quantity && !options[option_id][:quantity].empty?
                  selected_option[:quantity] = options[option_id][:quantity]
                else
                  selected_option[:quantity] = 1
                end
                
                total_selected_options += selected_option[:quantity].to_i
                
                selected_options.push(selected_option)
                
                logger.debug "Added checkbox option #{option_id}"
              end
            end
          else
            selected_option = {}
            selected_option[:option_id] = options[:selected]          
            selected_option[:quantity] = 1
            
            total_selected_options += selected_option[:quantity].to_i
            
            selected_options.push(selected_option)
            logger.debug "Added radio option #{options[:selected]}"
          end
          
          @all_selected_options += selected_options
          
          if (option_group.min_selected && (total_selected_options < option_group.min_selected)) || (option_group.max_selected && (total_selected_options > option_group.max_selected))
            @option_groups_in_error.push(option_group_id)
          end
          
          option_group_selections[option_group_id] = selected_options
        end
      end
    end
    
    if !@item_size_error && @option_groups_in_error.empty?
      @order[:items].push({
        :item_size_id => item_size_id,
        :option_groups => option_group_selections,
        :quantity => @quantity,
        :special_instructions => @special_instructions
      })
      
      @order[:restaurant_id] = current_restaurant.id
      
      session[:order] = @order
      
      rate()
      
      render :partial => 'showCart'
    else
      if !@item_size_error
        @item_size = ItemSize.find(item_size_id)
      end
      
      @item = Item.find(session[:selected_item_id])
      @item_sizes = @item.item_sizes
      @option_groups = @item.option_groups

      @category_available = @item.category.available?
      
      @item_sizes_available = 0
          
      if @item_sizes.length == 1 && @item_sizes[0].available? && @item_sizes[0].item_size_name.available? && @category_available
        @item_sizes_available = 1
      else
        @item_sizes.each do |item_size|
          if item_size.available? && item_size.item_size_name.available? && @category_available
            @item_sizes_available += 1
            
            if @item_sizes_available > 1
              break
            end
          end
        end
      end
      
      
      
      @form_action = "updateCart"
      
      @restaurant = current_restaurant
      @category_available = @item.category.available?
      
      @title = @restaurant.name + " - " + @item.name
      
      render :partial => 'selectOptions', :status => 444
    end
    
  end
  
  
  def updateExisting
    @order = session[:order]
    items = @order[:items]
    
    item_array_id = session[:selected_order_item]
            
    item_size_id = params[:order_item][:size]
    option_group_selections = {}
    
    option_groups_params = params[:option]
    
    @quantity = params[:order_item][:quantity]
    @special_instructions = params[:order_item][:special_instructions]
    
    @option_groups_in_error = checkOptionGroups(item_size_id, option_groups_params)
    @all_selected_options = []
    
    if option_groups_params
      option_groups_params.each do |option_group_id, options|
        selected_options = []
        
        option_group = OptionGroup.find(option_group_id)
        total_selected_options = 0
        
        if !option_group.min_selected || option_group.min_selected == 0 || !option_group.max_selected || option_group.max_selected > 1
          options.each do |option_id, selected|
            if options[option_id][:selected] == '1'
              
              option = Option.find(option_id)
              
              selected_option = {}
              
              selected_option[:option_id] = option_id
              
              if option.allow_quantity
                selected_option[:quantity] = options[option_id][:quantity]
              else
                selected_option[:quantity] = 1
              end
              
              total_selected_options += selected_option[:quantity].to_i
              
              selected_options.push(selected_option)
              logger.debug "Added checkbox option #{option_id}"
            end
          end
        else         
          selected_option = {}
          selected_option[:option_id] = options[:selected]          
          selected_option[:quantity] = 1
          
          total_selected_options += selected_option[:quantity].to_i
          
          selected_options.push(selected_option)
          logger.debug "Added radio option #{options[:selected]}"
        end
        
        @all_selected_options += selected_options
        
        if (option_group.min_selected && (total_selected_options < option_group.min_selected)) || (option_group.max_selected && (total_selected_options > option_group.max_selected))
          @option_groups_in_error.push(option_group_id)
        end
        
        option_group_selections[option_group_id] = selected_options
      end
    end
    
    if @option_groups_in_error.empty?
      items[item_array_id] = {
        :item_size_id => item_size_id,
        :option_groups => option_group_selections,
        :quantity => @quantity,
        :special_instructions => @special_instructions
      }
      
      rate()
            
      render :partial => 'showCart'
    else
      @item_size = ItemSize.find(item_size_id)
      @item = @item_size.item
      @option_groups = @item.option_groups
      
      @item_sizes = @item.item_sizes
      
      @form_action = "updateExisting"
      
      @restaurant = current_restaurant
      @category_available = @item.category.available?
      @title = @restaurant.name + " - " + @item.name
      
      render :partial => 'selectOptions', :status => 444
    end
    
  end
  
  
  def addPreviousOrder
    order = Order.find(params[:id])
    
    orderSession = initOrder()
    
    order.order_items.each do |order_item|
      option_group_selections = {}
      
      order_item.order_item_options.each do |order_item_option|
        option_group_id = order_item_option.option.option_group.id
        
        if option_group_selections[option_group_id] == nil
          option_group_selections[option_group_id] = []
        end
        
        selected_option = {}
        selected_option[:option_id] = order_item_option.option_id
        selected_option[:quantity] = order_item_option.quantity
        
        option_group_selections[option_group_id].push(selected_option)
      end
      
      orderSession[:items].push({
        :item_size_id => order_item.item_size_id,
        :option_groups => option_group_selections,
        :quantity => order_item.quantity
      })
    end
    
    orderSession[:restaurant_id] = order.restaurant_id
  
    session[:order] = orderSession

    rate()
    
    redirect_to :controller => "restaurant", :action => "showRestaurant", :id => orderSession[:restaurant_id]
  end
  
  
  
  def checkOptionGroups(item_size_id, option_groups_params)
    option_groups_in_error = []
    
    item_size = ItemSize.find(item_size_id)
    option_groups = item_size.item.option_groups
    
    
    if option_groups
      option_groups.each do |option_group|
        found = false
        
        if option_groups_params
          option_groups_params.each do |option_group_id, options|
            if option_group.id == option_group_id.to_i
              found = true
            end
          end
        end
        
        if !found
          option_groups_in_error.push(option_group.id)
        end
      end
    end
    
    return option_groups_in_error
  end
  
  
  
  def initOrder()    
    order = {
      :restaurant_id => current_restaurant.id,
      :items => []
    }
    
    if current_user
      order[:user_id] = current_user.id
    end
    
    return order
  end
  
  def remove
    index = params[:index]
    session[:order][:items].delete_at(index.to_i)
    
    rate()
    
    render :partial => 'showCart'
  end
  
  def refreshCart
    if params[:order_type]
      session[:order][:order_type] = params[:order_type]
    end
        
    rate()
    render :partial => 'showCart'
  end
  
  
  def emptyCart
    session[:order] = nil
    rate()
    
    render :partial => 'showCart'
  end
  
  def updateOrderType
    orderSession = session[:order]
    
    orderSession[:name] = params[:order][:name]
    orderSession[:phone] = params[:order][:phone]
    
    if !logged_in?
      orderSession[:email] = params[:order][:email]
    else
      orderSession[:email] = current_user.email
    end
    
    orderSession[:order_type] = params[:order][:order_type]
    
    if orderSession[:order_type] == "delivery"
      orderSession[:delivery_street1] = params[:order][:delivery_street1]
      orderSession[:delivery_street2] = params[:order][:delivery_street2]
      orderSession[:delivery_city] = params[:order][:delivery_city]
      orderSession[:delivery_state_id] = params[:order][:delivery_state_id]
      orderSession[:delivery_zip] = params[:order][:delivery_zip]
    end
    
    @order = Order.new()
    
    @order.name = orderSession[:name]
    @order.phone = orderSession[:phone]
    @order.email = orderSession[:email]
    
    @order.order_type = orderSession[:order_type]
    
    if orderSession[:order_type] == "delivery"
      @order.delivery_street1 = orderSession[:delivery_street1]
      @order.delivery_street2 = orderSession[:delivery_street2]
      @order.delivery_city = orderSession[:delivery_city]
      @order.delivery_state_id = orderSession[:delivery_state_id]
      @order.delivery_zip = orderSession[:delivery_zip]
    end
    
    restaurant = Restaurant.find(orderSession[:restaurant_id])
    
    rate()
    
    if @order.validate_order_type(restaurant)
      redirect_to :action => "selectPaymentType"
    else
      @user = current_user
      @restaurant = Restaurant.find(session[:order][:restaurant_id])
      
      @states = State.find(:all)
      @title = "Order Type"
      render :action => "selectOrderType"
    end
    
  end
  
  def updatePaymentType
    orderSession = session[:order]
    
    @save_to_user_profile = params[:save_to_user_profile]
    @credit_card_selection = params[:credit_card_selection]
    
    orderSession[:payment_type] = params[:order][:payment_type]
    
    @order = Order.new()
    @order.payment_type = orderSession[:payment_type]
    @order.restaurant_id = orderSession[:restaurant_id]
    
    if orderSession[:payment_type] == "credit_card"
      
      if @credit_card_selection == "saved"
        orderSession[:credit_card_type_id] = current_user.credit_card_type_id
        orderSession[:credit_card_number] = current_user.credit_card_number
        orderSession[:credit_card_expiration_month] = current_user.credit_card_expiration_month
        orderSession[:credit_card_expiration_year] = current_user.credit_card_expiration_year
        orderSession[:credit_card_code] = current_user.credit_card_code
        orderSession[:credit_card_first_name] = current_user.credit_card_first_name
        orderSession[:credit_card_last_name] = current_user.credit_card_last_name

        session[:order][:new_credit_card_type_id] = nil
        session[:order][:new_credit_card_number] = nil
        session[:order][:new_credit_card_expiration_month] = nil
        session[:order][:new_credit_card_expiration_year] = nil
        session[:order][:new_credit_card_code] = nil
        session[:order][:new_credit_card_first_name] = nil
        session[:order][:new_credit_card_last_name] = nil
      else
        orderSession[:credit_card_type_id] = params[:order][:credit_card_type_id]
        orderSession[:credit_card_number] = params[:order][:credit_card_number]
        orderSession[:credit_card_expiration_month] = params[:order][:credit_card_expiration_month]
        orderSession[:credit_card_expiration_year] = params[:order][:credit_card_expiration_year]
        orderSession[:credit_card_code] = params[:order][:credit_card_code]
        orderSession[:credit_card_first_name] = params[:order][:credit_card_first_name]
        orderSession[:credit_card_last_name] = params[:order][:credit_card_last_name]

        orderSession[:new_credit_card_type_id] = orderSession[:credit_card_type_id]
        orderSession[:new_credit_card_number] = orderSession[:credit_card_number]
        orderSession[:new_credit_card_expiration_month] = orderSession[:credit_card_expiration_month]
        orderSession[:new_credit_card_expiration_year] = orderSession[:credit_card_expiration_year]
        orderSession[:new_credit_card_code] = orderSession[:credit_card_code]
        orderSession[:new_credit_card_first_name] = orderSession[:credit_card_first_name]
        orderSession[:new_credit_card_last_name] = orderSession[:credit_card_last_name]
      end
        
      @order.credit_card_type_id = orderSession[:credit_card_type_id]
      @order.credit_card_number = orderSession[:credit_card_number]
      @order.credit_card_expiration_month = orderSession[:credit_card_expiration_month]
      @order.credit_card_expiration_year = orderSession[:credit_card_expiration_year]
      @order.credit_card_code = orderSession[:credit_card_code]
      @order.credit_card_first_name = orderSession[:credit_card_first_name]
      @order.credit_card_last_name = orderSession[:credit_card_last_name]
    end
    
    
    if @order.validate_payment_type?
      if @save_to_user_profile
        current_user.credit_card_type_id = orderSession[:credit_card_type_id]
        current_user.credit_card_number = orderSession[:credit_card_number]
        current_user.credit_card_expiration_month = orderSession[:credit_card_expiration_month]
        current_user.credit_card_expiration_year = orderSession[:credit_card_expiration_year]
        current_user.credit_card_code = orderSession[:credit_card_code]
        current_user.credit_card_first_name = orderSession[:credit_card_first_name]
        current_user.credit_card_last_name = orderSession[:credit_card_last_name]

        current_user.save
      end
      
      redirect_to :action => "reviewOrder"
    else
      @order.credit_card_type_id = nil
      @order.credit_card_number = nil
      @order.credit_card_expiration_month = nil
      @order.credit_card_expiration_year = nil
      @order.credit_card_code = nil
      @order.credit_card_first_name = nil
      @order.credit_card_last_name = nil
      
      
      @user = current_user
      
      @months = 1..12
      
      year = Time.now.year
      @years = year..(year+5)
      
      @restaurant = Restaurant.find(session[:order][:restaurant_id])
          
      @credit_card_types = @restaurant.credit_card_types
      
      @title = "Payment Type"
      render :action => "selectPaymentType"
    end
    
  end
  
  
  
  def createUser
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
            
      redirect_to :action => "selectOrderType"
    else      
      @states = State.find(:all)
      render :action => :register
    end
  end
  
  
  def createSession
    sessionParams = params[:session]
    
    if sessionParams
      self.current_user = User.authenticate(sessionParams[:email], sessionParams[:password])
      if logged_in?
        if sessionParams[:remember_me] == "1"
          self.current_user.remember_me
          cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
        end
        
        setCurrentAddressFromCurrentUser()
        
        session[:access_time] = $TIME_ZONE.now
        
        redirect_to :action => "selectOrderType"
        flash[:notice] = "Logged in successfully"
      else
        @states = State.find(:all)
        flash[:notice] = "Login Failed"
        render :action => :register
      end
    end
  end
  
  
  def sendTestFax()
    order = Order.new
    
    order.restaurant_id = current_restaurant.id
    order.user_id = current_user.id
    order.discount = 0
    order.sub_total = 0
    order.delivery_charge = 0
    order.tax = 0
    order.total_price = 0
    order.order_time = Time.now
    
    order.phone = "7175869483"
    order.name = "Peter Herr"
    
    order.order_type = "test"
    order.payment_type = "cash"
    
    order.order_number = "0000000000"
    
    order.status = "test"
    order.disclaimer_read = true
    
    faxOrder(order)
    
    flash[:notice] = "Test Fax Sent - Please verify with restaurant"
    redirect_to :controller => "restaurant", :action => "showRestaurantAdmin"
  end
  
  
  def faxOrder(order)
    success = false

    if (ENV['RAILS_ENV'] != 'production' && order.restaurant.fax != $TEST_FAX_NUMBER) || local_request?
      email = FaxMailer.create_order(order, false)
      
      FaxMailer.deliver(email)
      success = true
    else
      
      email = FaxMailer.create_order(order, true)
      
      ## Load GnuPG and the public key of your choice
      gnupg = GnuPG.new :recipient => "Protus IP Solutions <support@protus.com>"
      gnupg.load_public_key File.read("public/myfax.asc")
      
      ## If its loaded, create the mail, encrypt, send
      if gnupg.public_key_loaded?
        
        email.body = email.body.gsub("'", "\\\\047")
        
        logger.debug "email body BEFORE ENCRYPTION: " + email.body
        
        email.body = gnupg.encrypt(email.body)
        
        logger.debug "email body AFTER ENCRYPTION: " + email.body
        
        FaxMailer.deliver(email)
        success = true
      else
        logger.error "Encryption Failed - Order not sent"
      end

    end
    
    return success
  end
  
  
  def callRestaurant(order)
    restaurant_phone = order.restaurant.phone1
    customer_phone = order.phone.gsub(/[^\d]/, '') 
    
    makeCall(restaurant_phone, 'https://forkfile.com/phone/orderScript?phone=' + customer_phone)
  end
    
  
  def check_if_cart_expired
    order = session[:order]
    
    expired = false
    
    if order != nil
      restaurant = Restaurant.find(order[:restaurant_id])
      
      if !restaurant.isOpen
        expired = true
      elsif order[:order_type] == "delivery" && !restaurant.isDeliveryAvailable
        expired = true
      elsif order[:order_type] == "take_out" && !restaurant.isTakeOutAvailable
        expired = true
      end
     
      if !expired
        order[:items].each do |item|
          item_size = ItemSize.find(item[:item_size_id])
          item = item_size.item
          
          if !item_size.available?
            expired = true
            break
          elsif !item.category.available?
            expired = true
            break
          end
        end
      end
      
    else
      expired = true
    end
    
    if expired
      flash[:notice] = "Your Order Has Expired"
      order = nil
      redirect_to :controller => "restaurant", :action => "showRestaurant"
    end
  end
  
end
