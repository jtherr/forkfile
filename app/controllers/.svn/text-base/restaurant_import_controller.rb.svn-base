require "csv"

class RestaurantImportController < ApplicationController
  before_filter :admin_required
  before_filter :check_for_restaurant

  def selectFile
    @title = "Import Items"
  end
  
  
  def exportToCsv    
    categories = current_restaurant.categories.find(:all, :order => "position")
    
    csvData = StringIO.new
    CSV::Writer.generate(csvData, ',') do |row|
      categories.each do |category|
        items = category.items.find(:all, :order => "position")
      
        items.each do |item|
          
          data = [item.category.name, item.name, item.description]
                  
          item.item_sizes.each do |item_size|
            data.push(item_size.item_size_name.name)
            data.push(item_size.price)
          end
          
          row << data
        end
      end
    end
    csvData.rewind
    send_data(csvData.read,:type=>'text/csv;charset=iso-8859-1;header=present',
      :filename=>'restaurant_items.csv', :disposition =>'attachment', :encoding => 'utf8')
  end
  
  
  def import
    @errors = []
    
    file = params[:csv_file]
    
    if file == nil || file == ""
      @errors.push("Please upload a CSV file")
    else
        
      categories = []
      item_sizes = []
      
      items = []
      
      line_num = 1
      while (line = file.gets)
        columns = CSV.parse_line(line)
  
        if (columns.length <= 3)
          @errors.push("Not enough columns on line #{line_num}. Found #{columns.length} columns.")
          break
        end
        
        prices = []
        
        item = {}
      
        item[:category] = columns[0]
        item[:name] = columns[1]
        item[:description] = columns[2]
        
        
        if item[:category] == nil
          @errors.push("All categories must be filled out")
          break
        else
          item[:category].strip!
        end
        
        if item[:name] == nil
          @errors.push("All item names must be filled out")
          break
        else
          item[:name].strip!
        end
        
        if item[:description] != nil
          item[:description].strip!
        end
        
        
        i = 3
        while (i < columns.length) do
          price = {}
          
          label = columns[i]
          value = columns[i + 1]
  
          if (i == 3 || (label != nil && !label.empty?)) && (value == nil || value.empty?)
            @errors.push("All prices must be filled out")
            break
          elsif value != nil && !value.empty?
            price[:label] = label || ""
            price[:value] = value.strip
                      
            prices.push(price)
            
            if label != nil && !label.empty?
              label.strip!
              item_sizes.push(label)
            end
          end
        
          i+=2
        end
        
        item[:prices] = prices
      
        categories.push(item[:category])
      
      
        items.push(item)
        
        line_num += 1
      end
    end
    
    if @errors.empty?
      categories.uniq!
      item_sizes.uniq!

      @added_categories = []
      @added_item_size_names = []
      @added_items = []

      categories.each do |name|
        processCategory(name)
      end

      item_sizes.each do |name|
        processItemSizeName(name)
      end

      items.each do |new_item|
        processItem(new_item)
      end

      if @errors.empty?
        @title = "Import Results"
        render :action => "importResults"
      else
        @title = "Import Items"
        render :action => "selectFile"
      end
    else
      @title = "Import Items"
      render :action => "selectFile"
    end
    
  end
  
  
  def processCategory(name)
    category = Category.find(:first, :conditions => [ "restaurant_id = #{current_restaurant.id} AND name = ?", name ] )
    
    if category == nil
      createCategory(name)    
    end
  end
  
  
  def createCategory(name)
    max_position = current_restaurant.categories.maximum(:position) || 0
    
    category = Category.new(:name => name, :restaurant_id => current_restaurant.id, :position => max_position + 1)    
    if category.save
      @added_categories.push(category.name)
    end
  end
  
  
  def processItemSizeName(name)
    item_size_name = ItemSizeName.find(:first, :conditions => [ "restaurant_id = #{current_restaurant.id} AND name = ?", name ] )
    
    if item_size_name == nil
      createItemSizeName(name)    
    end
  end
  
  
  def createItemSizeName(name)
    item_size_name = ItemSizeName.new(:name => name, :restaurant_id => current_restaurant.id)    
    if item_size_name.save
      @added_item_size_names.push(item_size_name.name)
    end
  end
  
  
  def processItem(item)
    category = Category.find(:first, :conditions => [ "restaurant_id = #{current_restaurant.id} AND name = ?", item[:category] ] )

    name = item[:name]
    description = item[:description]
    
    if description == nil
      description = ""
    end
    
    new_item = Item.find(:first, :conditions => [ "name = ? AND restaurant_id = #{current_restaurant.id} AND category_id = #{category.id}", name ] )
    
    if new_item == nil
      max_position = current_restaurant.items.maximum(:position) || 0
        
      new_item = Item.new(
          :category_id => category.id,
          :name => name, 
          :description => description, 
          :restaurant_id => current_restaurant.id,
          :vegetarian => false,
          :featured => false,
          :spicy => false,
          :position => max_position + 1,
          :status_id => $ACTIVE
      )
      
      if new_item.save
        @added_items.push(item)
      else
        @errors.push("Unable to add item: '#{new_item.name}' with description: '#{new_item.description}'")
        @errors.push(new_item.errors.full_messages.to_s)
        return
      end
    end
        
    item[:prices].each do |price|
      processItemPrice(new_item.id, price[:label], price[:value])
    end
  end
  
  def processItemPrice(item_id, label, value)
    value.sub!('$', '')

    item_size_name = ItemSizeName.find(:first, :conditions => [ "restaurant_id = #{current_restaurant.id} AND name = ?", label ] )
    
    item_size = ItemSize.find(:first, :conditions => [ "item_id = #{item_id} AND item_size_name_id = #{item_size_name.id} AND price = ?", value ])
    
    if item_size == nil
      item_size = ItemSize.new(
          :item_id => item_id,
          :item_size_name_id => item_size_name.id, 
          :price => value,
          :special_only => false)
      item_size.save
    end
  end
  
  
end