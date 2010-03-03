class DiscountController < ApplicationController

  before_filter :admin_required

  before_filter :check_for_restaurant

  def showDiscounts    
    @discounts = current_restaurant.discounts.find(:all, :order => "priority")
    @discount_groups = current_restaurant.discount_groups
    
    @title = current_restaurant.name + ": Discounts"
  end
  
  def addDiscount
    @discount_groups = current_restaurant.discount_groups
    
    @title = "Add Discount"
    render :partial => "addDiscount"
  end
  
  def editDiscount
    @discount = Discount.find(params[:id])
    @discount_groups = current_restaurant.discount_groups
    
    @title = "Edit Discount"
    render :partial => "editDiscount"
  end
  
  def addDiscountGroup
    @title = "Add Discount Group"
    render :partial => "addDiscountGroup"
  end
  
  def editDiscountGroup
    @discount_group = DiscountGroup.find(params[:id])
    @title = "Edit Discount Group"
    render :partial => "editDiscountGroup"
  end
  
  
  def showDiscountGroup
    discount_group_id = params[:id] || session[:discount_group_id]
    session[:discount_group_id] = discount_group_id
    @discount_group = DiscountGroup.find(discount_group_id)
    @discount_group_parts = @discount_group.discount_group_parts
    @title = "Discount Group: " + @discount_group.name
  end
  
  def addDiscountGroupPart
    @categories = current_restaurant.categories.find(:all, :order => "name")
    @title = "Add Discount Group Part"
    render :partial => "addDiscountGroupPart"
  end
  
  def editDiscountGroupPart
    @discount_group_part = DiscountGroupPart.find(params[:id])
    @categories = current_restaurant.categories.find(:all, :order => "name")
    
    category = Category.find(@discount_group_part.category_id)
    @items = category.items
    
    if @discount_group_part.item_id
      item = Item.find(@discount_group_part.item_id)
      @option_groups = item.option_groups      
      @item_size_names = item.item_size_names
      
      if @discount_group_part.option_group_id
        @option_group = OptionGroup.find(@discount_group_part.option_group_id)   
      end
      
    else
      @item_size_names = category.item_size_names
    end
    
    
    @title = "Edit Discount Group Part"
    render :partial => "editDiscountGroupPart"
  end
  
  
  def processCategory    
    if params[:category_id] && !params[:category_id].empty?
      session[:category_id] = params[:category_id]
      
      category = Category.find(session[:category_id])
      @items = category.items
      @item_size_names = category.item_size_names
    end
    
    render :partial => "items"
  end

  def processItem
    if params[:item_id] && !params[:item_id].empty?
      item = Item.find(params[:item_id])
      @option_groups = item.option_groups      
      @item_size_names = item.item_size_names
    else
      category = Category.find(session[:category_id])
      @item_size_names = category.item_size_names
    end
    
    render :partial => "optionGroups"
  end
  
  def processOptionGroup
    if params[:option_group_id] && !params[:option_group_id].empty?
      @option_group = OptionGroup.find(params[:option_group_id])   
    end
    
    render :partial => "optionGroup"
  end
  
  
  def changePriority
    @discounts = current_restaurant.discounts.find(:all, :order => "priority")
    @title = "Change Discount Priority"
    render :partial => "changePriority"
  end
  
  
  def showDiscountHours
    @discount = Discount.find(params[:id])
    session[:discount_id] = @discount.id
    
    @hours = @discount.discount_hours
    @title = "Discount Hours"
  end
  
  def editHour
    @hour = DiscountHour.find(params[:id])
    @weekdays = Weekday.find(:all)
    
    @time_options = getTimeOptions()
    
    @title = "Edit Discount Hours"
    render :partial => 'editHour'
  end
  
  def addHour
    @weekdays = Weekday.find(:all)
    
    @time_options = getTimeOptions()
    
    @title = "Add Discount Hours"
    render :partial => 'addHour'
  end
  
  
  
  def createDiscount      
    max_priority = current_restaurant.discounts.maximum(:priority) || 0
  
  
    @discount = Discount.new(params[:discount])
    @discount.restaurant_id = current_restaurant.id
    @discount.priority = max_priority + 1
    
    if @discount.save
      @discounts = current_restaurant.discounts.find(:all, :order => "priority")
      render :partial => 'discounts'
    else
      @discount_groups = current_restaurant.discount_groups

      @title = "Add Discount"
      render :partial => 'addDiscount', :status => 444
    end
    
  end
  
  
  def updateDiscount      
    @discount = Discount.find(params[:id])
    
    if @discount.update_attributes(params[:discount])
      @discounts = current_restaurant.discounts.find(:all, :order => "priority")
      render :partial => 'discounts'
    else
      @discount_groups = current_restaurant.discount_groups

      @title = "Edit Discount"
      render :partial => 'editDiscount', :status => 444
    end
    
  end
  
  
  def deleteDiscount
    discount = Discount.find(params[:id])
    discount.destroy()
    
    @discounts = current_restaurant.discounts.find(:all, :order => "priority")
    render :partial => "discounts"
  end
  
  
  def createDiscountGroup
    @discount_group = DiscountGroup.new(params[:discount_group])
    @discount_group.restaurant_id = current_restaurant.id
    
    if @discount_group.save
      session[:discount_group_id] = @discount_group.id
      @title = "Add Discount Group"
      render :partial => 'addDiscountGroup'
    else      
      @title = "Add Discount Group"
      render :partial => 'addDiscountGroup', :status => 444
    end
  end
  
  
  
  def createDiscountGroupPart
    @discount_group_part = DiscountGroupPart.new(params[:discount_group_part])
    @discount_group_part.discount_group_id = session[:discount_group_id]
    
    if @discount_group_part.save
      discount_group = DiscountGroup.find(session[:discount_group_id])
      @discount_group_parts = discount_group.discount_group_parts
      render :partial => 'discountGroupParts'
    else
      @categories = current_restaurant.categories.find(:all, :order => "name")
      
      if @discount_group_part.category_id
        category = Category.find(@discount_group_part.category_id)
        @items = category.items
        @item_size_names = current_restaurant.item_size_names
      end


      if @discount_group_part.item_id
        item = Item.find(@discount_group_part.item_id)
        @option_groups = item.option_groups
      end
    

      if @discount_group_part.option_group_id
        @option_group = OptionGroup.find(@discount_group_part.option_group_id)   
      end

      
      @title = "Add Discount Group Part"
      
      render :partial => 'addDiscountGroupPart', :status => 444
    end
    
  end
  
  def updateDiscountGroupPart
    @discount_group_part = DiscountGroupPart.find(params[:id])
    
    if @discount_group_part.update_attributes(params[:discount_group_part])
      discount_group = DiscountGroup.find(session[:discount_group_id])
      @discount_group_parts = discount_group.discount_group_parts
      render :partial => 'discountGroupParts'
    else
      @categories = current_restaurant.categories.find(:all, :order => "name")
      
      if @discount_group_part.category
        category = Category.find(@discount_group_part.category_id)
        @items = category.items
        @item_size_names = current_restaurant.item_size_names

        if @discount_group_part.item
          item = Item.find(@discount_group_part.item_id)
          @option_groups = item.option_groups
      
          if @discount_group_part.option_group
            @option_group = OptionGroup.find(@discount_group_part.option_group_id)   
          end
        end
      end

      @title = "Edit Discount Group Part"
      
      render :partial => 'editDiscountGroupPart', :status => 444
    end
  end
  
  
  def deleteDiscountGroupPart
    discount_group_part = DiscountGroupPart.find(params[:id])
    discount_group_part.destroy()
    
    discount_group = DiscountGroup.find(session[:discount_group_id])
    @discount_group_parts = discount_group.discount_group_parts
    render :partial => "discountGroupParts"
  end
  
  
  
  def updateDiscountGroup
    @discount_group = DiscountGroup.find(params[:id])
    
    if @discount_group.update_attributes(params[:discount_group])
      @discount_groups = current_restaurant.discount_groups
      render :partial => 'discountGroups'
    else
      @title = "Edit Discount Group"
      render :partial => 'editDiscountGroup', :status => 444
    end
  end
  
  
  def deleteDiscountGroup
    discount_group = DiscountGroup.find(params[:id])
    discount_group.destroy()
    
    @discount_groups = current_restaurant.discount_groups
    render :partial => "discountGroups"
  end
  
  
  def updatePriority
    params[:discountList].each_with_index do |id, priority|
      Discount.update(id, :priority => priority)
    end
    render :nothing => true
  end
  
  
  def createHour
    discount = Discount.find(session[:discount_id])
    
    @hour = DiscountHour.new(params[:hour])
    
    @hour.discount_id = discount.id
    
    if @hour.save
      @hours = discount.discount_hours
      render :partial => "hours"
    else
      @weekdays = Weekday.find(:all)
      @time_options = getTimeOptions()
      
      render :partial => "addHour", :status => 444
    end
  end
  
  def updateHour
    discount = Discount.find(session[:discount_id])
    
    @hour = DiscountHour.find(params[:id])
    
    if @hour.update_attributes(params[:hour])
      @hours = discount.discount_hours
      render :partial => "hours"
    else
      @weekdays = Weekday.find(:all)
      @time_options = getTimeOptions()

      render :partial => "editHour", :status => 444
    end
  end
  
  
  def deleteHour
    discount = Discount.find(session[:discount_id])
    
    hour = DiscountHour.find(params[:id])
    
    if hour.destroy()
      @hours = discount.discount_hours
      render :partial => "hours"
    else
      @hours = discount.discount_hours
      render :partial => "hours", :status => 444
    end
    
  end
  
  
  
end