# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include AddressTracker
  include RestaurantTracker
  include GeoKit::Geocoders  
  include SslRequirement

  require 'config/constants.rb'
  require 'config/links.rb'
  require 'config/box_layouts.rb'
  
  layout 'standard'
  
  
  helper :all # include all helpers, all the time
  
  helper_method :super_admin?, :admin?, :owner?, :customer?
  
  before_filter :instantiate_controller_and_action_names
  before_filter :check_authentication
  before_filter :check_search_terms
  before_filter :initSubNavLinks
  before_filter :init_display_boxes
  before_filter :init_cart
  before_filter :app_enabled_check
  before_filter :notification_count
  
  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  #protect_from_forgery :only => '298b2d535fecedb78107ceddcac14572'
  

  def super_admin?
    if logged_in?
      current_user.privilege_id == $SUPER_ADMIN
    end
  end
  
  def admin?
    if logged_in?
      current_user.privilege_id == $ADMIN || current_user.privilege_id == $SUPER_ADMIN
    end
  end
  
  def owner?
    if logged_in?
      current_user.privilege_id == $OWNER
    end    
  end
  
  def customer?
    if logged_in?
      current_user.privilege_id == $CUSTOMER
    end
  end

  def session_authenticated?
    return logged_in? && session[:access_time] != nil && ($TIME_ZONE.now < (session[:access_time] + 30.minutes))
  end


  def super_admin_required
    if super_admin? 
      session_authentication_required()
    else 
      no_access()
    end
  end
  
  def admin_required
    if admin?
      session_authentication_required()
    else 
      no_access()
    end
  end
  
  def owner_required
    if owner? 
      session_authentication_required()
    else 
      no_access()
    end
  end
  
  def authentication_required
    logged_in? || no_access()
  end
  
  def session_authentication_required
    if !session_authenticated?
      must_authenticate()
    end
  end
  
  def session_authentication_required_if_logged_in
    if !session_authenticated? && logged_in?
      must_authenticate()
    end
  end
  
  def check_authentication
    if session_authenticated?
      session[:access_time] = $TIME_ZONE.now
    end
  end
  
  
  def must_authenticate
    session[:next_controller] = controller_name
    session[:next_action] = action_name
    session[:next_params] = params
        
    respond_to do |format|
      format.html { redirect_to :controller => "session", :action => "loginAndContinue" }
      format.js { render :partial => "session/login" }
    end    
  end
  
  
  def check_search_terms
    if session[:search_terms] == nil
      session[:search_terms] = {}
    end
  end
  
  
  def check_for_restaurant
    if !restaurant_stored?
      session_expired()
    end
  end
  
  def check_for_address
    if !address_stored? && (params[:search] == nil)
      logger.debug("current address null - redirecting to session expired")
      session_expired()
    end
  end
  
  def no_access
    logger.debug("no access - redirecting to index")
    redirect_to :controller => 'main', :action => 'index'
  end
  
  
  def run_captcha
    if params[:inputfield] == nil || params[:inputfield] != ""
      redirect_to :controller => 'main', :action => 'index'
    end
  end
  
  
  
  def addSubNavLinks(links)
    @enabledLinks = {} if !@enabledLinks
    links.each do |linkId|
      @enabledLinks.merge!(linkId => true)
    end
  end
  
  
  def app_enabled_check
    @appEnabled = logged_in? || (Restaurant.count(:all, :conditions => "status_id = #{$ACTIVE}") > 0)
  end
  
  def notification_count
    if admin?
      @openNotifications = Notification.count(:conditions => "status = 0")
      @newNotifications = Notification.count(:conditions => "viewed = false")
    end
  end
  
  
  def instantiate_controller_and_action_names
    @current_action = action_name
    @current_controller = controller_name
    
    @isSessionExpiredView = controller_name == "session" && action_name == "sessionExpired"
    
    @isSignUpView = controller_name == "users" && (action_name == "register" || action_name == "create" || action_name == "orderRegister")
    @isLoginView = controller_name == "session" && (action_name == "login" || action_name == "create" || action_name == "orderLogin")
    
    @isHomeView = controller_name == "main" && action_name != "adminHome"
    @isIndexView = controller_name == "main" && action_name == "index"
    @isPortalView = controller_name == "main" && (action_name == "portal" || action_name == "restaurantOwnerHome" || action_name == "adminHome")
    @isNotificationView = controller_name == "notification" && (action_name == "contactUs" || action_name == "restaurantOwners")
    
    
    @isSpecialsView = controller_name == "special" && (action_name == "specials" || action_name == "returnToSpecials")
    @isFavoritesView = controller_name == "favorite" && (action_name == "favorites" || action_name == "returnToFavorites")
    @isRecentOrdersView = controller_name == "order" && (action_name == "showRecentOrders" || action_name == "viewPreviousOrder")
    
    @isBrowseView = controller_name == "search" && (action_name == "browse" || action_name == "basicSearch" || action_name == "returnToRestaurants" || action_name == "searchResults")
    
    @isRestaurantView = controller_name == "restaurant" && (action_name == "showRestaurant" || action_name == "showSpecials" || action_name == "showMap" || action_name == "showHours" || action_name == "showAdditionalInfo")
    
    @isOrderView = controller_name == "order" && action_name != "showRecentOrders" && action_name != "viewPreviousOrder" && action_name != "viewCurrentOrder"
    
    @isEnterOrderView = controller_name == "order" && (action_name == "enterOrder" || action_name == "submitOrder")
    @isOrderTypeView = controller_name == "order" && (action_name == "selectOrderType" || action_name == "updateOrderType")
    @isPaymentTypeView = controller_name == "order" && (action_name == "selectPaymentType" || action_name == "updatePaymentType")
    @isReviewOrderView = controller_name == "order" && (action_name == "reviewOrder" || action_name == "confirmOrder")
    
    
    @isTabView = !@isSessionExpiredView && (!@isOrderView || (controller_name == "order" && (action_name == "showConfirmation" || action_name == "register")))
    
    @isCartView = @isOrderView || @isRestaurantView || (controller_name == "order" && action_name == "showConfirmation")
    
    @isUpdateCart = controller_name == "order" && (action_name == "updateCart" || action_name == "updateExisting" || action_name == "remove" || action_name == "refreshCart" || action_name == "emptyCart")

    @showStepBar = @isHomeView || @isNotificationView || @isBrowseView || @isSpecialsView || @isFavoritesView || @isRecentOrdersView || @isRestaurantView || @isOrderView || (controller_name == "order" && action_name == "viewCurrentOrder")
  
  end
  
  
  def init_display_boxes
#    @displayCart = false
    @displaySidebar = false
    @bodyClass = "full"
    
#    $CART_PAGES.each do |page|
#     (controller, action) = page.split('/')
#      if @current_controller == controller && @current_action == action
#        @displayCart = true
#        @bodyClass = "medium"
#        break
#      end
#    end

    if @isCartView
      @bodyClass = "medium"
    end
    
    $SIDEBAR_PAGES.each do |page|
     (controller, action) = page.split('/')
      if @current_controller == controller && @current_action == action
        @displaySidebar = true
        if @isCartView
          @bodyClass = "small"
        else
          @bodyClass = "large"
        end
        break
      end
    end
  end
  
  def searchRestaurants()
    restaurants = []
    
    keywords = session[:search_terms][:keywords]
    
    beginTimestamp = $TIME_ZONE.now
    
    
    if address_stored?
      tmp_restaurants = []
      
      
      # EXTRA CONDITIONS SHOULD NOT BE FROM USER KEYWORDS!!!
      
      extra_conditions = ""
      if session[:search_terms][:delivery]
        extra_conditions += " (delivery = true AND distance <= delivery_radius) AND"
      end
      
      if session[:search_terms][:take_out]
        extra_conditions += " (take_out = true) AND"
      end
      
      if session[:search_terms][:cuisine_id] != nil
        extra_conditions += " (cuisines.id = #{session[:search_terms][:cuisine_id]}) AND"
      end
        
      if session[:search_terms][:favorites]
        tmp_restaurants += current_user.favorite_restaurants.find(:all, :order => "restaurants.name",
          :include => [ :cuisines ],
          :origin => [current_address[:lat], current_address[:lng]],
          :conditions => [ "#{extra_conditions} restaurants.status_id = ?", $ACTIVE ] )
      else
        
        if keywords != nil && !keywords.empty?
          wordList = getKeywordList(keywords)
          
          wordList.each do |word|
          
            tmp_restaurants += Restaurant.find(:all,
              :include => [ :items, :cuisines, :categories ],
              :conditions => [ "#{extra_conditions} (restaurants.name LIKE ? OR items.name LIKE ? OR cuisines.name LIKE ? OR categories.name LIKE ?) AND restaurants.status_id = ?", "%#{word}%", "%#{word}%", "%#{word}%", "%#{word}%", $ACTIVE ], 
              :origin => [current_address[:lat], current_address[:lng]], :order => "distance", :within => $DEFAULT_SEARCH_DISTANCE)
          
          end
        else
          tmp_restaurants += Restaurant.find(:all,
            :include => [ :cuisines ],
            :conditions => [ "#{extra_conditions} restaurants.status_id = ?", $ACTIVE ], 
            :origin => [current_address[:lat], current_address[:lng]], :order => "distance", :within => $DEFAULT_SEARCH_DISTANCE)
        end
      
      end
      
      if session[:search_terms][:open] || session[:search_terms][:specials]
        tmp_restaurants = filterRestaurants(tmp_restaurants)
      end
  
      restaurants = tmp_restaurants.uniq.paginate :page => params[:page], :per_page => $DEFAULT_ITEMS_PER_PAGE
    end
    
    searchDuration = $TIME_ZONE.now - beginTimestamp
    
    logger.debug("Search duration was: #{searchDuration}")
    
    return restaurants
  end
  
  
  def filterRestaurants(tmp_restaurants)
    return_restaurants = []
    
    tmp_restaurants.each do |restaurant|
      open = restaurant.isOpen
      
      if open
        if session[:search_terms][:specials]
          if (!restaurant.current_specials.empty? || !restaurant.current_discounts.empty?)
            return_restaurants.push(restaurant)
          end
        elsif session[:search_terms][:open]
          return_restaurants.push(restaurant)
        end
      end
    end
    
    return return_restaurants
  end
  
  
  
  def getKeywordList(keywords)
    wordList = []
    
    splitOnQuotes = keywords.split(/[\"\']/)
    
    i=0
    splitOnQuotes.each do |quotesSegment|
      if !quotesSegment.empty?
        if i%2 == 1
          wordList.push(quotesSegment)          
        else
          splitOnSpaces = quotesSegment.split(" ")
          splitOnSpaces.each do |spacesSegment|
            if !spacesSegment.empty?
              wordList.push(spacesSegment)
            end
          end
          
        end
      end
      
      i += 1
    end
    
    return wordList
  end
  
  
  def rate
    sub_total = 0
    
    order = session[:order]
    
    if order != nil
      restaurant = Restaurant.find(order[:restaurant_id])
      
      items = order[:items]
      
      if items != nil
        items.each do |item|
          
          item[:discount_status] = "not_applied"
          quantity = item[:quantity].to_i
          item_size = ItemSize.find(item[:item_size_id])
          current_price = item_size.current_price
          
          
          if current_price != nil
          
            total_item_price = current_price 
  
            item[:option_groups].each do |option_group_id, selected_options|
              option_group = OptionGroup.find(option_group_id)
              total_selected_options = 0
            
              selected_options.each do |selected_option|              
                option = Option.find(selected_option[:option_id])
                total_item_price += option.additional_price_for_option(item_size.item_size_name.id) * selected_option[:quantity].to_f
                total_selected_options += selected_option[:quantity].to_i
              end
  
              if (option_group.quantity_price_increase && option_group.price_increase)
                total_item_price += (total_selected_options - option_group.quantity_price_increase) * option_group.price_increase
              end
              
            end
            
            item[:price] = total_item_price * quantity
            
            sub_total += item[:price]
          
          else
            session[:order][:items].delete(item)
          end
        end
      end
      
      discount = getDiscount(restaurant, order, sub_total)
      
      sub_total = sub_total - discount
      
      delivery_charge = 0
      if order[:order_type] == "delivery"
        delivery_percent = 0
        if restaurant.delivery_percent != nil
          delivery_percent = restaurant.delivery_percent
        end
        
        delivery_charge = restaurant.delivery_charge + delivery_percent * 0.01 * sub_total
      end
      
      tax = getTax(restaurant, sub_total, delivery_charge)
      total_price = getTotal(sub_total, delivery_charge, tax)
      
      order[:discount] = discount
      order[:sub_total] = sub_total
      order[:delivery_charge] = delivery_charge
      order[:tax] = tax
      order[:total_price] = total_price
    end
  end
  
  
  def getDiscount(restaurant, order, sub_total)    
    sorted_order_items = getSortedOrderItems(order[:items])
    
    discounts = restaurant.discounts.find(:all, :order => "priority")
    
    total_discount_amount = 0
    discount_applied = false
    
    order[:discounts_applied] = []
    
    discounts.each do |discount|
      discount_amount = processDiscount(discount, sorted_order_items, order, sub_total, discount_applied)
      total_discount_amount += discount_amount
      
      if discount_amount > 0
        discount_applied = true
        
        if !discount.allow_combo
          break
        end
      end
    end
    
    logger.debug("total discount amount = " + total_discount_amount.to_s)
  
    return total_discount_amount
  end
  
  def getSortedOrderItems(order_items)
    individual_order_items = []
    order_items.each do |order_item|
      if order_item[:quantity].to_i > 1
        individual_price = order_item[:price] / order_item[:quantity].to_i
        item_size_id = order_item[:item_size_id]
        option_groups = order_item[:option_groups]
        
        (1..order_item[:quantity].to_i).each do |i|
          individual_order_item = {}

          individual_order_item[:item_size_id] = item_size_id
          individual_order_item[:discount_status] = "not_applied"
          individual_order_item[:price] = individual_price
          individual_order_item[:quantity] = 1
          individual_order_item[:option_groups] = option_groups
          
          individual_order_items.push(individual_order_item)
        end
      else
        individual_order_items.push(order_item)
      end
    end
    
    return individual_order_items.sort { |a,b| b[:price] <=> a[:price]  }
  end
  
  
  def processDiscount(discount, sorted_order_items, order, sub_total, other_discount_applied)
    match = false
    discount_applied = false
    discount_amount = 0

    logger.debug("processing discount: " + discount.name)

    if ((order[:order_type] == nil || order[:order_type].empty?) && (!discount.delivery || !discount.take_out)) ||
      (order[:order_type] == "delivery" && !discount.delivery) || 
      (order[:order_type] == "take_out" && !discount.take_out)
      return 0
    end


    if (!other_discount_applied || (discount.allow_combo && (discount.buy_discount_group != nil || discount.get_discount_group != nil))) && discount.available?
      if discount.buy_discount_group != nil
        logger.debug("buy discount group")
        
        buy_match_count = 0

        matched_discount_group_parts = []
        
        sorted_order_items.each do |order_item|
          item_size = ItemSize.find(order_item[:item_size_id])

          discount_group_part = nil
          
          discount_group_parts = discount.buy_discount_group.matchingParts(item_size)
          discount_group_parts.each do |part|
            if !discount.buy_match_all_parts || !matched_discount_group_parts.include?(part.id)
              discount_group_part = part
              break
            end
          end

          match_discount_option_group = determineIfDiscountOptionGroupMatch(discount_group_part, order_item)

          if (order_item[:discount_status] == "not_applied") && discount_group_part != nil && match_discount_option_group
            buy_match_count += 1
            order_item[:discount_status] = "pending"

            matched_discount_group_parts.push(discount_group_part.id)
          end
          
          matched_discount_group_parts.uniq!
          
          if (discount.buy_match_all_parts && (matched_discount_group_parts.length == discount.buy_discount_group.discount_group_parts.length)) || 
            (!discount.buy_match_all_parts && (buy_match_count == discount.buy_quantity))
            logger.debug("matched buy quantity")
            
            match = true
            break
          end
        end
        
        if !match
          buy_match_count = 0
        end

      elsif !discount.buy_amount || sub_total >= discount.buy_amount
        logger.debug("matched buy price")
        match = true
      end


      if match
    
        if discount.get_discount_group != nil
          logger.debug("get discount group")
          
          get_match = false
          
          discount_items_count = 0
          discount_items_amount = 0
          
          matched_discount_group_parts = []
          
          sorted_order_items.each do |order_item|
            item_size = ItemSize.find(order_item[:item_size_id])

            discount_group_part = nil
            
            discount_group_parts = discount.get_discount_group.matchingParts(item_size)
            discount_group_parts.each do |part|
              if !discount.get_match_all_parts || !matched_discount_group_parts.include?(part.id)
                discount_group_part = part
                break
              end
            end

            match_discount_option_group = determineIfDiscountOptionGroupMatch(discount_group_part, order_item)

            if (order_item[:discount_status] == "not_applied") && discount_group_part != nil && match_discount_option_group
              discount_items_count += 1
              discount_items_amount += order_item[:price]
              order_item[:discount_status] = "pending"
              
              matched_discount_group_parts.push(discount_group_part.id)
            end
            
            matched_discount_group_parts.uniq!
            
            if (discount.get_match_all_parts && (matched_discount_group_parts.length == discount.get_discount_group.discount_group_parts.length)) || 
              (!discount.get_match_all_parts && (discount_items_count == discount.get_quantity))
              logger.debug("matched get quantity, discount items amount = " + discount_items_amount.to_s)
              
              get_match = true
              break
            end
          end
          
          if get_match
            
            if discount.get_for_amount != nil
              discount_amount = discount_items_amount - discount.get_for_amount
              discount_applied = true   
            elsif sub_total - (discount_items_amount * discount.get_percent_off * 0.01 + discount.get_amount_off) >= discount.buy_amount
              discount_amount = discount_items_amount * discount.get_percent_off * 0.01 + discount.get_amount_off
              discount_applied = true   
            end
            
            logger.debug("discount amount = " + discount_amount.to_s)
          end
  
        else          
          get_percent_off = discount.get_percent_off || 0
          get_amount_off = discount.get_amount_off || 0
          
          discount_amount = sub_total * get_percent_off * 0.01 + get_amount_off
          discount_applied = true
          
          logger.debug("matched get amount off, discount_amount = " + discount_amount.to_s)
        end
  
      end
  
    end
  
    if discount_applied
      order_discount = {}
      order_discount[:name] = discount.name
      order_discount[:amount] = discount_amount
      
      order[:discounts_applied].push(order_discount)
      
      sorted_order_items.each do |order_item|
        if order_item[:discount_status] == "pending"
          order_item[:discount_status] = "applied"
        end
      end
    else
      sorted_order_items.each do |order_item|
        if order_item[:discount_status] == "pending"
          order_item[:discount_status] = "not_applied"
        end
      end
    end
  
  
    if discount_applied && discount.allow_combo && (discount.buy_discount_group != nil || discount.get_discount_group != nil)
      discount_amount += processDiscount(discount, sorted_order_items, order, sub_total, true)
    end
    
    logger.debug("returning discount amount" + discount_amount.to_s)
    
    return discount_amount
  end
  
  
  
  def determineIfDiscountOptionGroupMatch(discount_group_part, order_item)
    match_discount_option_group = true
    if discount_group_part != nil
      discount_group_option_group_id = discount_group_part.option_group_id
      
      if discount_group_option_group_id != nil            
        match_discount_option_group = false
        
        discount_group_option_group_quantity = discount_group_part.option_group_quantity

        order_item[:option_groups].each do |option_group_id, selected_options|
          if discount_group_option_group_id == option_group_id.to_i
            option_group_quantity = 0
            
            selected_options.each do |selected_option|
              option_group_quantity += selected_option[:quantity].to_i
            end
            
            if discount_group_option_group_quantity == option_group_quantity
              match_discount_option_group = true

              logger.debug("matched option group")
            end
            break
          end
        end
      end
    end
    
    return match_discount_option_group
  end
  
  
  def getTax(restaurant, sub_total, delivery_charge)
    state = State.find(restaurant.state_id)
    
    locality_tax = LocalityTax.find(:first, :conditions => [ "state_id = ? AND (county_name = ? OR city_name = ?)", restaurant.state_id, restaurant.county, restaurant.city] )
    
    sales_tax = state.tax.sales_tax
    
    if locality_tax != nil
      if locality_tax.meal_tax != nil
        sales_tax += locality_tax.meal_tax
      end
    end
    
    return (sub_total + delivery_charge) * sales_tax * 0.01
  end

  def getTotal(sub_total, delivery_charge, tax)
    return sub_total + delivery_charge + tax
  end
  
  
  
  def initSubNavLinks    
    displaySubNav = $SUBNAV_PAGES.include?("#{@current_controller}/#{@current_action}")

    @subNavLinks = []
    if displaySubNav      
      $SUBNAV_LINKS.each do |link|
        props = linkProperties[link]
        
        if !props[:hidden]
          @subNavLinks.push(props)
        end
      end
    end
  end
  
  
  def linkProperties
    return {
      "showRestaurant" => { :name => "Customer View", :controller => "restaurant", :action => "showRestaurant", :id => session[:restaurant_id], :hidden => !admin? },
      "showRestaurantAdmin" => { :name => "Restaurant", :controller => "restaurant", :action => "showRestaurantAdmin", :hidden => !admin? },
      "showAllItems" => { :name => "Items", :controller => "item", :action => "showAllItems", :hidden => !admin? },
      "changeCuisines" => { :name => "Cuisines", :controller => "restaurant", :action => "changeCuisines", :hidden => !admin? },
      "manageHours" => { :name => "Hours", :controller => "restaurant_hour", :action => "manageHours", :hidden => !admin? },
      "showOptionGroups" => { :name => "Option Groups", :controller => "option_group", :action => "showOptionGroups", :hidden => !admin? },
      "showItemSizeNames" => { :name => "Item Sizes", :controller => "item_size_name", :action => "showItemSizeNames", :hidden => !admin? },
      "showCategories" => { :name => "Categories", :controller => "category", :action => "showCategories", :hidden => !admin? },
      "showDiscounts" => { :name => "Discounts", :controller => "discount", :action => "showDiscounts", :hidden => !admin? },
      "showLogo" => { :name => "Logo", :controller => "logo", :action => "showLogo", :hidden => !admin? },
      "showRestaurantOrders" => { :name => "Orders", :controller => "restaurant_order", :action => "showRestaurantOrders", :hidden => !admin? },
      "reorderItems" => { :name => "Reorder Items", :controller => "item", :action => "reorderItems", :hidden => !admin? }
    }
  end
  
  
  def init_cart
    @cart_items = 0
    
    order = session[:order]
    if order != nil
      items = order[:items]

      if items != nil
        @cart_items = items.length
      end
    end
  end
  
  
  def getCuisines(restaurants)
    cuisines = {}
    
    restaurants.each do |restaurant|
      restaurant.cuisines.each do |cuisine|
        if cuisines[cuisine.id] == nil
          cuisines[cuisine.id] = { :name => cuisine.name, :count => 1 }
        else
          cuisines[cuisine.id][:count] += 1
        end
      end
    end
    
    return cuisines.sort{ |a,b| b[1][:count] <=> a[1][:count] }
  end
  
  
  def findItems(restaurant, wordList, category_id)
    
    category_condition = ""
    if category_id != nil
      category_condition = " AND category_id = #{category_id} "
    end
    
    
    items = []
    
    if wordList != nil
      wordList.each do |word|
        items += Item.find(:all, :include => [ { :item_sizes => [ :special_hours, :item_size_name ] }, :category ],
          :conditions => [ "items.restaurant_id = #{restaurant.id} AND items.name LIKE ? AND items.status_id = ? #{category_condition}", "%#{word}%", $ACTIVE ],
          :order => "items.position, item_sizes.price")
      end
    else
      items += Item.find(:all, :include => [ { :item_sizes => [ :special_hours, :item_size_name ] }, :category ],
        :conditions => [ "items.restaurant_id = #{restaurant.id} AND items.status_id = ?  #{category_condition}", $ACTIVE ],
        :order => "items.position, item_sizes.price")
    end
    
    @display_items = {}
    @height_count = 0
    
    items.each do |item|
      if item.available?
        category = item.category
        
        if @display_items[category.id] == nil
          category_info = {}
          category_info[:name] = category.name
          category_info[:available] = category.available?
          category_info[:description] = category.description
          category_info[:position] = category.position
          category_info[:items] = []
          
          @display_items[category.id] = category_info
          
          @height_count += 2
          
          if category.description != nil && !category.description.empty?
            @height_count += 1
          end
          
        end
        
        if !item.description.empty?
          @height_count += 1
        end
        
        @display_items[category.id][:items].push(item)
        
        @height_count += 1
      end
    end
  
    @display_items = @display_items.sort { |a, b| a[1][:position] <=> b[1][:position] }
  
  end
  
  
  def getTimeOptions
    options = []
    
     (0..23).each do |military_hour|
      hour = 0
      ampm = 'AM'
      
      if military_hour <= 11
        ampm = 'AM'
        
        if military_hour == 0
          hour = 12
        else
          hour = military_hour
        end
      else
        ampm = 'PM'
        
        if military_hour == 12
          hour = 12
        else
          hour = military_hour - 12
        end
      end
      
      ['00', '15', '30', '45'].each do |minute|
        options.push(:id => "#{military_hour}:#{minute}", :name => "#{hour}:#{minute} #{ampm}")
      end
    end
    
    return options
  end
  
  
  def session_expired    
    respond_to do |format|
      format.html { redirect_to :controller => "session", :action => "sessionExpired" }
      format.js { render :partial => "session/sessionExpired" }
    end
  end
  
end
