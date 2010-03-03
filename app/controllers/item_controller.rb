class ItemController < ApplicationController
  
  before_filter :admin_required, :except => [ :filterByCategory, :showAllCategories, :searchItems ]

  before_filter :check_for_restaurant
  
  def showAllItems
    @item_search = params[:item_search]
    
    @status = $ACTIVE
    @category_search = ""
    if params[:item]
      if params[:item][:status]
        @status = params[:item][:status]
      end
      
      if params[:item][:category]
        @category_search = params[:item][:category]
      end
    end
    
    session[:item_search] = @item_search
    session[:item_status] = @status
    session[:item_category] = @category_search
    
    adminItemSearch()
  end
  
  def backToAllItems
    adminItemSearch()
    render :action => "showAllItems"
  end
  
  
  def adminItemSearch
    @restaurant = current_restaurant
    @categories = @restaurant.categories.find(:all, :order => "position")
    
    @item_search = session[:item_search]
    @status = session[:item_status]
    @category_search = session[:item_category]
    
    category_condition = ""
    if @category_search && @category_search != ""
      category_condition = "category_id = #{@category_search} AND "
    end
    
    @items = Item.paginate :page => params[:page], :per_page => 20, :conditions => [ "#{category_condition} restaurant_id = ? AND name LIKE ? and status_id = ?", @restaurant.id, "%#{@item_search}%", @status ], :order => "category_id, position"
    
    @option_groups = @restaurant.option_groups
    
    @title = @restaurant.name + ": " + $DB_STATUSES[@status.to_i][:name] + " Items"
  end
  
  
  
  def searchItems
    session[:item_search] = params[:item_search]
    
    @restaurant = current_restaurant

    @wordList = getKeywordList(session[:item_search])

    findItems(@restaurant, @wordList, nil)

    @singleColumn = true
    
    render :partial => "items"
  end

  
  def showItem
    @item = Item.find(params[:id])
    @restaurant = @item.restaurant
    
    @option_groups = @item.option_groups
    
    session[:item_id] = @item.id
    @item_sizes = @item.item_sizes
    
    @title = @restaurant.name + " Item: " + @item.name
  end
  
  
  def editItem
    @item = Item.find(params[:id])
    session[:item_id] = @item.id
    @categories = Category.find(:all, :conditions => "restaurant_id = #{current_restaurant.id}", :order => "position")
    
    render :partial => 'editItem'
  end
  
  
  def addItem
    @item_size_names = current_restaurant.item_size_names
    
    @categories = Category.find(:all, :conditions => "restaurant_id = #{current_restaurant.id}", :order => "position")
    @action = "createItem"
    
    render :partial => 'addItem'
  end
  
  
  def addItemAdmin
    @item_size_names = current_restaurant.item_size_names
    
    @categories = Category.find(:all, :conditions => "restaurant_id = #{current_restaurant.id}", :order => "position")
    @action = "createItemAdmin"

    render :partial => 'addItem'
  end
  
  
  def addItemSize    
    @item_size_names = current_restaurant.item_size_names
    render :partial => 'addItemSize'
  end
  
  def editItemSize
    @item_size = ItemSize.find(params[:id])
    
    @item_size_names = current_restaurant.item_size_names
    
    session[:item_size_id] = @item_size.id
    
    render :partial => 'editItemSize'
  end
  
  
  def reorderItems
    @restaurant = current_restaurant
    @categories = @restaurant.categories.find(:all, :order => 'position')
    @itemLists = @categories.collect{ |category| "itemList_#{category.id}" }
    
    @title = @restaurant.name + ": Reorder Items"
  end
  
  def alphaOrder
    category = Category.find(params[:id])
    
    items = category.items.find(:all, :order => "name")
    
    i = 0
    items.each do |item|
      item.update_attributes(:position => i)
      i += 1
    end
    
    redirect_to :action => "reorderItems"
  end
  
  
  def linkOptionGroup
    @option_groups = current_restaurant.option_groups
    
    @title = "Link Option Group"
    
    render :partial => "linkOptionGroup"
  end
  
  
  
  def createItem
    @restaurant = current_restaurant
    max_position = @restaurant.items.maximum(:position) || 0
    
    item = Item.new(params[:item])
    item.restaurant_id = current_restaurant.id
    item.position = max_position + 1
    
    valid = true
    @itemSizes = []
    @errors = []
    
    if !item.valid?
      valid = false
      @errors.push(item)
    end
    
    itemSizeParams = params[:itemSize]
    if itemSizeParams
      itemSizeParams.each do |i, itemSizeValue|
        itemSize = item.item_sizes.build(itemSizeValue)
        if !itemSize.valid?
          valid = false
          @errors.push(itemSize)
        end
        @itemSizes.push(itemSize)
      end
    end
    
    if valid && item.save
      adminItemSearch()
      
      render :partial => "items"
    else
      @item_size_names = @restaurant.item_size_names
      
      @action = "createItem"
      
      @categories = Category.find(:all, :conditions => "restaurant_id = #{current_restaurant.id}", :order => "position")
      render :partial => "addItem", :status => 444
    end
    
  end
  
  
  def createItemAdmin
    @restaurant = current_restaurant
    max_position = @restaurant.items.maximum(:position) || 0
    
    @item = Item.new(params[:item])
    @item.restaurant_id = current_restaurant.id
    @item.position = max_position + 1
    
    
    valid = true
    @itemSizes = []
    @errors = []
    
    if !@item.valid?
      valid = false
      @errors.push(@item)
    end
    
    itemSizeParams = params[:itemSize]
    if itemSizeParams
      itemSizeParams.each do |i, itemSizeValue|
        itemSize = @item.item_sizes.build(itemSizeValue)
        if !itemSize.valid?
          valid = false
          @errors.push(itemSize)
        end
        @itemSizes.push(itemSize)
      end
    end
    
    if valid && @item.save
      adminItemSearch()
      
      render :partial => "itemListAdmin"
    else
      @item_size_names = @restaurant.item_size_names
      
      @action = "createItemAdmin"
      
      @categories = Category.find(:all, :conditions => "restaurant_id = #{current_restaurant.id}", :order => "position")
      render :partial => "addItem", :status => 444
    end
    
  end
  
  
  def updateItem
    @item = Item.find(params[:id])
    
    if @item.update_attributes(params[:item])
      render :partial => "itemInfo"
    else
      @categories = Category.find(:all, :conditions => "restaurant_id = #{current_restaurant.id}", :order => "position")
      render :partial => "editItem", :status => 444
    end
  end
  
  
  def deleteItem
    @restaurant = current_restaurant
    @item = Item.find(params[:id])
    
    @item_search = session[:item_search]
    @status = session[:item_status]
    
    if @item.update_attributes(:status_id => $DELETED)
      @categories = @restaurant.categories.find(:all, :order => "position")
      @items = @restaurant.items.paginate :page => params[:page], :per_page => 20, :conditions => [ "name LIKE ? and status_id = ?", "%#{@item_search}%", @status ], :order => "category_id, name"  

      render :partial => "itemListAdmin"
    else
      @categories = @restaurant.categories.find(:all, :order => "position")
      @items = @restaurant.items.paginate :page => params[:page], :per_page => 20, :conditions => [ "name LIKE ? and status_id = ?", "%#{@item_search}%", @status], :order => "category_id, name"  

      render :partial => "itemListAdmin", :status => 444
    end
  end
  
  
  def deleteItemAndShowAll
    @restaurant = current_restaurant
    @item = Item.find(params[:id])
    
    if @item.update_attributes(:status_id => $DELETED)
      redirect_to :action => "backToAllItems"
    else
      @option_groups = @item.option_groups      
      @item_sizes = @item.item_sizes
      
      @title = @restaurant.name + " Item: " + @item.name
      
      render :action => "showItem"
    end
  end
  
  
  
  def createItemSize
    @item_size = ItemSize.new(params[:item_size])
    @item_size.item_id = session[:item_id]
    
    if @item_size.save
      @item = Item.find(session[:item_id])
      render :partial => "itemSizes"
    else
      @item_size_names = current_restaurant.item_size_names
      
      render :partial => "addItemSize", :status => 444
    end
  end
  
  def updateItemSize
    @item_size = ItemSize.find(params[:id])
    
    if @item_size.update_attributes(params[:item_size])
      @item = Item.find(session[:item_id])
      render :partial => "itemSizes"
    else
      @item_size_names = current_restaurant.item_size_names
      
      render :partial => "editItemSize", :status => 444
    end
  end
  
  def deleteItemSize
    @item_size = ItemSize.find(params[:id])
    
    if @item_size.update_attributes(:status_id => $DELETED)
      @item = Item.find(session[:item_id])
      render :partial => "itemSizes"
    else
      @item = Item.find(session[:item_id])
      render :partial => "itemSizes", :status => 444
    end
  end
  

  
  def filterByCategory
    session[:category_id] = params[:id]

    session[:item_search] = nil
    @restaurant = current_restaurant
    @categories = @restaurant.categories.find(:all, :conditions => "id = #{params[:id]}")
    
    findItems(@restaurant, nil, params[:id])
    
    @singleColumn = true
    
    render :partial => "items"
  end
  
  def showAllCategories
    session[:category_id] = nil
    
    session[:item_search] = nil
    @restaurant = current_restaurant

    findItems(@restaurant, nil, nil)

    @singleColumn = false
    
    render :partial => "items"
  end
  
  def updateOrder
    params.each do |key, value|
      key_split = key.split("_")
    
      if key_split.length == 2 && key_split[0] == "itemList"
        params[key].each_with_index do |id, position|
          Item.update(id, {:position => position, :category_id => key_split[1]})
        end
      end
    end

    render :nothing => true
  end
  
  
  def changeStatus
    status_id = params[:item_update][:new_status]
    
    if status_id.empty?
      @item_action_error = "Please select a new item status"
    else
      item_ids = []
      
      params.each do |key, value|
        if key =~ /^item_select_/
          key_split = key.split("item_select_")
          if key_split.length == 2
            item_ids.push(key_split[1].to_i)
          end
        end      
      end
      
      logger.debug "items selected = " + item_ids.join(',')
      
      if item_ids.empty?
        @item_action_error = "No items were selected"
      else
        item_ids.each do |item_id|
          Item.find(item_id).update_attributes(:status_id => status_id)
        end
      end
    end
    
    adminItemSearch()
    render :action => "showAllItems"
  end
  
  def linkItemsToOptionGroup
    option_group_id = params[:item_update][:option_group_id]
    
    if option_group_id.empty?
      @item_action_error = "Please select an option group to link"
    else
      item_ids = []
      
      params.each do |key, value|
        if key =~ /^item_select_/
          key_split = key.split("item_select_")
          if key_split.length == 2
            item_ids.push(key_split[1].to_i)
          end
        end      
      end
      
      logger.debug "items selected = " + item_ids.join(',')
      
      if item_ids.empty?
        @item_action_error = "No items were selected"
      else
        item_ids.each do |item_id|
          item_option_group = ItemOptionGroup.new(:option_group_id => option_group_id, :item_id => item_id)
          item_option_group.save        
        end
      end
    end
    
    adminItemSearch()
    render :action => "showAllItems"
  end
  
  
  def createItemOptionGroup
    @item_option_group = ItemOptionGroup.new(params[:item_option_group])
    @item_option_group.item_id = session[:item_id]
    
    if @item_option_group.save
      item = Item.find(session[:item_id])
      @option_groups = item.option_groups
      
      render :partial => "linkedOptionGroups"
    else
      @option_groups = current_restaurant.option_groups
      
      @title = "Link Option Group"
      
      render :partial => "linkOptionGroup", :status => 444
    end
  end
  
  def deleteItemOptionGroup
    item = Item.find(session[:item_id])

    @item_option_group = ItemOptionGroup.find(:first, :conditions => "item_id = #{item.id} and option_group_id = #{params[:id]}")
    
    item = Item.find(session[:item_id])
    @option_groups = item.option_groups
        
    @item_option_group.destroy()
    
    render :partial => "linkedOptionGroups"
  end
  
  
end