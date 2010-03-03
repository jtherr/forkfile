class ItemSizeNameController < ApplicationController
  
  before_filter :admin_required
  
  before_filter :check_for_restaurant
  
  def showItemSizeNames
    @restaurant = current_restaurant
    @item_size_names = @restaurant.item_size_names
    
    @title = @restaurant.name + ": Item Size Names"
  end
  
  
  def addItemSizeName
    @title = "Add Item Size Name"
    
    render :partial => "addItemSizeName"
  end
  
  
  def editItemSizeName
    @item_size_name = ItemSizeName.find(params[:id])
    @title = "Edit Item Size Name"
    
    render :partial => "editItemSizeName"
  end
  
  def createItemSizeName
    @restaurant = current_restaurant
    
    @item_size_name = ItemSizeName.new(params[:item_size_name])
    @item_size_name.restaurant_id = @restaurant.id
    
    if @item_size_name.save
      @item_size_names = @restaurant.item_size_names
      render :partial => "itemSizeNames"
    else
      @title = "Add Item Size Name"
      
      render :partial => "addItemSizeName", :status => 444
    end
  end
  
  def updateItemSizeName
    @restaurant = current_restaurant
    
    @item_size_name = ItemSizeName.find(params[:id])
    
    if @item_size_name.name != ""
      if @item_size_name.update_attributes(params[:item_size_name])
        @item_size_names = @restaurant.item_size_names
        render :partial => "itemSizeNames"
      else
        @title = "Edit Item Size Name"
        
        render :partial => "editItemSizeName", :status => 444
      end
    end
  end
  
  
  def deleteItemSizeName
    @restaurant = current_restaurant
    
    item_size_name = ItemSizeName.find(params[:id])
    
    if item_size_name.name != ""
      if item_size_name.destroy()
        @item_size_names = @restaurant.item_size_names
        render :partial => "itemSizeNames"
      else
        @item_size_names = @restaurant.item_size_names
        render :partial => "itemSizeNames", :status => 444
      end
    end
  end
  
end
