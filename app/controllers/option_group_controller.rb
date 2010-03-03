class OptionGroupController < ApplicationController
  
  before_filter :admin_required
  
  before_filter :check_for_restaurant  
  
  def showOptionGroups    
    @option_groups = current_restaurant.option_groups
    
    @title = "Restaurant Option Groups"
  end
  
  def showOptionGroup
    @option_group = OptionGroup.find(params[:optionGroupId])
    @restaurant = @option_group.restaurant
    
    @item_size_names = @restaurant.item_size_names
    
    session[:option_group_id] = @option_group.id
    
    @title = @restaurant.name + ", Option Group: " + @option_group.name
  end  
  
    
  def addOptionGroup
    @restaurant = current_restaurant
    
    @item_size_names = @restaurant.item_size_names
    
    @itemSizeIdArray = []
    @itemSizeNameArray = []
    @item_size_names.each do |item_size_name|
      @itemSizeIdArray.push(item_size_name.id)
      @itemSizeNameArray.push(item_size_name.name)
    end
    
    
    render :partial => 'addOptionGroup'
  end
  
  
  def editOptionGroup
    @option_group = OptionGroup.find(params[:id])
    session[:option_group_id] = @option_group.id
    
    render :partial => 'editOptionGroup'
  end
  
  
  def addOption
    @restaurant = current_restaurant
    @item_size_names = @restaurant.item_size_names
    
    @itemSizeIdArray = []
    @itemSizeNameArray = []
    @item_size_names.each do |item_size_name|
      @itemSizeIdArray.push(item_size_name.id)
      @itemSizeNameArray.push(item_size_name.name)
    end
    
    render :partial => 'addOption'
  end
  
  
  def editOption
    @restaurant = current_restaurant
    
    @item_size_names = @restaurant.item_size_names
    
    @itemSizeIdArray = []
    @itemSizeNameArray = []
    @item_size_names.each do |item_size_name|
      @itemSizeIdArray.push(item_size_name.id)
      @itemSizeNameArray.push(item_size_name.name)
    end
        
    @option = Option.find(params[:id])
    @option_sizes = @option.option_sizes
    
    #MAKE SURE A OPTION SIZE EXISTS FOR EACH ITEM SIZE NAME
    
    @item_size_names.each do |item_size_name|
      found = false
            
      @option_sizes.each do |option_size|
        if option_size.item_size_name.id == item_size_name.id
          found = true
        end
      end
      
      if !found
        @option_sizes.create(:option_id => @option.id, :item_size_name_id => item_size_name.id)
      end
    end
    
    render :partial => 'editOption'
  end
  
  
  def showSubOptionGroups
    @restaurant = current_restaurant
    @option_groups = @restaurant.option_groups
    @option = Option.find(params[:id])
    
    session[:option_id] = @option.id
    
    @linked_sub_option_groups = @option.option_groups
    
    @title = @option.name + ": Sub-Option Groups"
    
    render :partial => 'showSubOptionGroups'
  end
  
  
  
  def createOptionGroup
    @restaurant = current_restaurant
    
    @option_group = @restaurant.option_groups.build(params[:option_group])
    
    valid = true
    @options = []
    @errors = []
    
    if !@option_group.valid?
      valid = false
      @errors.push(@option_group)
    end
    
    
    optionParams = params[:option]
    if optionParams
      optionParams.each do |optionKey, optionValue|
        option = @option_group.options.build(optionValue)
        
        if !option.valid?
          valid = false
          @errors.push(option)
        end
        
        if params[:option_size] != nil
          optionSizeParams = params[:option_size][optionKey]
          if optionSizeParams
            optionSizeParams.each do |optionSizeKey, optionSizeValue|
           
              option_size = option.option_sizes.build(optionSizeValue)
              
              if !option_size.valid?
                valid = false
                @errors.push(option_size)
              end
            end
          end
        end
        
        @options.push(option)
      end
    end
    
    if valid && @restaurant.save
      @option_groups = @restaurant.option_groups
      
      render :partial => 'optionGroups'
    else
      @itemSizeIdArray = []
      @itemSizeNameArray = []
      @restaurant.item_size_names.each do |item_size_name|
        @itemSizeIdArray.push(item_size_name.id)
        @itemSizeNameArray.push(item_size_name.name)
      end
      
      @item_size_names = @restaurant.item_size_names
      
      render :partial => "addOptionGroup", :status => 444
    end
  end
  
  
  def updateOptionGroup
    @option_group = OptionGroup.find(params[:id])
    
    if @option_group.update_attributes(params[:option_group])
      render :partial => "optionGroupInfo"
    else
      render :partial => "editOptionGroup", :status => 444
    end
  end
  
  
  def deleteOptionGroup
    @option_group = OptionGroup.find(params[:id])
        
    @option_group.update_attributes(:status_id => $DELETED)
    
    redirect_to :action => "showOptionGroups"
  end
  
  
  
  def createOption
    @option_group = OptionGroup.find(session[:option_group_id])
    
    @restaurant = @option_group.restaurant
    
    @item_size_names = @restaurant.item_size_names

    @option = @option_group.options.build(params[:option])
    
    valid = true
    @errors = []
    @option_sizes = []
    
    if !@option.valid?
      valid = false
      @errors.push(@option)
    end
    
    optionSizeParams = params[:option_size]
    if optionSizeParams
      optionSizeParams.each do |optionKey, optionValues|
        optionValues.each do |optionSizeKey, optionSizeValue|
          option_size = @option.option_sizes.build(optionSizeValue)
          
          if !option_size.valid?
            valid = false
            @errors.push(option_size)
          end
          
          @option_sizes.push(option_size)
        end
      end
    end
    
    if valid && @option_group.save
      render :partial => 'options'
    else
      @item_size_names = @restaurant.item_size_names
      
      @itemSizeIdArray = []
      @itemSizeNameArray = []
      @item_size_names.each do |item_size_name|
        @itemSizeIdArray.push(item_size_name.id)
        @itemSizeNameArray.push(item_size_name.name)
      end
      
      
      render :partial => "addOption", :status => 444
    end
  end
  
  
  def updateOption    
    @option = Option.find(params[:id])
    @option.attributes = params[:option]
    
    @restaurant = @option.option_group.restaurant
    
    @item_size_names = @restaurant.item_size_names
    
    valid = true
    @errors = []
    @option_sizes = []
    
    if !@option.valid?
      valid = false
      @errors.push(@option)
    end
    
    optionSizeParams = params[:option_size]
    if optionSizeParams
      optionSizeParams.each do |optionKey, optionValues|
        optionValues.each do |optionSizeKey, optionSizeValue|
          itemSizeNameId = optionSizeValue[:item_size_name_id]
          additionalPrice = optionSizeValue[:additional_price]
        
          option_size = @option.option_sizes.find(:first, :conditions => { :option_id => @option.id, :item_size_name_id => itemSizeNameId } )
          
          if option_size != nil
            option_size.attributes = { :item_size_name_id => itemSizeNameId, :additional_price => additionalPrice }
          
            if !option_size.valid?
              valid = false
              @errors.push(option_size)
            end
          else
            option_size = OptionSize.new(:option_id => @option.id, :item_size_name_id => itemSizeNameId, :additional_price => additionalPrice )
          end
        
          @option_sizes.push(option_size)
        end
      end
    end
    
    @option.option_sizes.each do |existing_option_size|
      found = false
      
      @option_sizes.each do |updated_option_size|
        if existing_option_size.id == updated_option_size.id
          found = true
        end
      end
      
      if !found
        existing_option_size.attributes = { :additional_price => 0.00 }
        @option_sizes.push(existing_option_size)
      end
    end
    
    
    if valid && @option.save
      @option_sizes.each do |option_size|
        option_size.save
      end
           
            
      @option_group = @option.option_group
      render :partial => 'options'
    else
      @item_size_names = @restaurant.item_size_names
      
      @itemSizeIdArray = []
      @itemSizeNameArray = []
      @item_size_names.each do |item_size_name|
        @itemSizeIdArray.push(item_size_name.id)
        @itemSizeNameArray.push(item_size_name.name)
      end
      
      render :partial => "editOption", :status => 444
    end
  end
  

  
  def deleteOption
    @option = Option.find(params[:id])
    @option_group = @option.option_group

    @restaurant = @option_group.restaurant
    @item_size_names = @restaurant.item_size_names

    if @option.update_attributes(:status_id => $DELETED)
      render :partial => "options"
    else
      render :partial => "options", :status => 444
    end
  end
  
  
  def createSubOptionGroup
    @option = Option.find(session[:option_id])

    @sub_option_group = SubOptionGroup.new(params[:sub_option_group])
    @sub_option_group.option_id = @option.id

    
    if @sub_option_group.save
      @linked_sub_option_groups = @option.option_groups
      
      render :partial => "linkedSubOptionGroups"
    else
      @restaurant = current_restaurant
      @option_groups = @restaurant.option_groups
      @linked_sub_option_groups = @option.option_groups
      
      @title = @option.name + ": Sub-Option Groups"
      
      render :partial => "showSubOptionGroups", :status => 444
    end
  end
  
  def deleteSubOptionGroup
    option = Option.find(session[:option_id])
    
    sub_option_group = SubOptionGroup.find(:first, :conditions => [ "option_id = ? and option_group_id = ?", option.id, params[:id] ])
        
    sub_option_group.destroy()
    
    @linked_sub_option_groups = option.option_groups
    
    render :partial => "linkedSubOptionGroups"
  end
  
end