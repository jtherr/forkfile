module FaxHelper
  
  def getBody(o)
    topLines = getTopLines(o)
    
    leftLines = getLeftSideLines(o)
    rightLines = getRightSideLines(o)
    
    body = ""
    
    topLines.each do |line|
      body += line + "\\r\\n"
    end
    
    getLeftRightLines(leftLines, rightLines).each do |line|
      body += line + "\\r\\n"
    end
    
    return body
  end
  
  def getTopLines(o)
    lines = []
    
    if o.order_type == "test"
      lines.push("forkfile.com                   ****** THIS IS A TEST ORDER - DO NOT MAKE ******")
    elsif o.order_type == "delivery"
      lines.push("forkfile.com                                         Order for *** DELIVERY ***")
    else
      lines.push("forkfile.com                                                 Order for Take Out")
    end
    
    lines.push("")
    lines.push("Fax:           (888) 407-9296")
    lines.push("Address:       PO Box 6541, Falls Church, VA 22040")
    lines.push("Email:         support@forkfile.com")
    lines.push("================================================================================")
    
    return lines
  end
  
  def getLeftSideLines(o)
    lines = []
    
    lines += labelAndValue("Restaurant:", o.restaurant.name)
    lines += labelAndValue("Account #:", o.restaurant.account_number.to_s)
    lines.push("---------------------------------------")
    
    lines += labelAndValue("Order Time:", $TIME_ZONE.utc_to_local(o.order_time).strftime("%m/%d/%y  %I:%M %p"))
    lines += labelAndValue("Order #:", o.order_number.to_s)
    lines.push("---------------------------------------")
    
    lines += labelAndValue("Customer Name:", o.name)
    lines += labelAndValue("Phone:", number_to_phone(o.phone))
    
    if o.order_type == "test"
      lines += labelAndValue("Order Type:", "*** TEST FAX ***")
    elsif o.order_type == "delivery"
      lines += labelAndValue("Order Type:", "*** DELIVERY ***")
      lines += labelAndValue("Delivery Addr:", o.address)
    else
      lines += labelAndValue("Order Type:", "Take Out")
    end
    
    lines.push("---------------------------------------")
    
    if o.payment_type == "credit_card"
      lines += labelAndValue("Payment Type:", "Credit Card")
      lines += labelAndValue("Card #:", o.credit_card_number.to_s)
      lines += labelAndValue("Card Exp:", o.credit_card_expiration_month.to_s + "/" + o.credit_card_expiration_year.to_s)
      lines += labelAndValue("Card Code:", o.credit_card_code.to_s)
      lines += labelAndValue("Card Name:", o.credit_card_first_name + " " + o.credit_card_last_name)
    else
      lines += labelAndValue("Payment Type:", "Cash")
    end
    
    return lines
  end
  
  def getRightSideLines(o)
    lines = []
    
    lines.push("ITEMS")
    lines.push("")
    lines.push("QTY ITEM                           PRICE")
    
    if o.order_type == "test"
      lines.push("----------------------------------------")
      lines += getItem("1", "Test Dinner", "$0.00", "Option 1, Option 2", "DO NOT MAKE - THIS IS A TEST")
      lines.push("----------------------------------------")
      lines += getItem("2", "Test Dessert", "$0.00", "", "DO NOT MAKE - THIS IS A TEST")    
    else
    
      o.order_items.each do |order_item|
        quantity = order_item.quantity
        item_size = order_item.item_size
        item = item_size.item
        total_item_price = item_size.current_price
        
        item_value = item.name
        
        item_size_name = item_size.item_size_name
        if !item_size_name.name.empty?
          item_value += " (" + item_size_name.name + ")"
        end
        
        options_formatted = []
        
        option_groups = item.option_groups
        if !option_groups.empty?
          
          option_groups.each do |option_group|
            
            total_selected_options = 0
            
            if option_group != nil
              
              order_item.orderOptionsInOptionGroup(option_group.id).each do |order_item_option|
                option = order_item_option.option
                
                option_quantity = order_item_option.quantity
                
                additional_price = option.additional_price_for_option(item_size.item_size_name.id)
                
                option_formatted = ""
                
                if option_quantity && option_quantity.to_i > 1
                  option_formatted += "(#{option_quantity}) "
                end
                
                
                option_formatted += option.name
                
                if additional_price > 0
                  option_formatted += " (+" + number_to_currency(additional_price) + ")"
                end
                
                options_formatted.push(option_formatted)
                total_item_price += additional_price * option_quantity.to_f
                total_selected_options += option_quantity.to_i
              end
              
              
              if (option_group.quantity_price_increase && option_group.price_increase)
                total_item_price += (total_selected_options - option_group.quantity_price_increase) * option_group.price_increase
              end
            end
          end
        end

        total_item_price = total_item_price * quantity
        
        lines.push("----------------------------------------")
        lines += getItem(quantity, item_value, number_to_currency(total_item_price), options_formatted.join(", "), order_item.special_instructions)
      end
      
    end
      
    lines.push("========================================")
    
    if o.discount > 0
      lines.push(labelAndPrice("Discount:", "- " + number_to_currency(o.discount)))
    end
    
    lines.push(labelAndPrice("Sub Total:", number_to_currency(o.sub_total)))
    
    if o.order_type == "delivery"
      lines.push(labelAndPrice("Delivery Charge:", number_to_currency(o.delivery_charge)))
    end
    
    lines.push(labelAndPrice("Tax:", number_to_currency(o.tax)))
    lines.push("----------------------------------------")
    lines.push(labelAndPrice("TOTAL:", number_to_currency(o.total_price)))    
    
    return lines
  end
  
  
  
  def labelAndValue(label, value)
    labelSize = 15
    valueSize = 24
    
    lines = []
    
    label = label.ljust(labelSize)
    
    if value != nil
      if value.length > valueSize
        lastSpaceIndex = value[0..(valueSize - 1)].rindex(' ') || valueSize
        
        lines.push(label + value[0..(lastSpaceIndex)].ljust(valueSize))
        lines += labelAndValue("", value[(lastSpaceIndex + 1)..-1])
      else
        lines.push(label + value.ljust(valueSize))
      end
    end
    
    return lines
  end
  
  
  def labelAndPrice(label, price)
    labelSize = 32
    priceSize = 7
    
    label = label.rjust(labelSize)
    price = price.rjust(priceSize)
    
    return label + " " + price
  end
  
  def getItem(quantity, item, price, options, special_instructions)
    optionsSize = 22
    instructionsSize = 24
    leftSize = 3
    centerSize = 28
    rightSize = 7
    
    lines = []
    
    quantity = quantity.to_s.ljust(leftSize)
    price = price.rjust(rightSize)
    
    if item != nil && !item.empty?
      item = item.ljust(centerSize)
      
      if item.length > centerSize
        lastSpaceIndex = item[0..(centerSize - 1)].rindex(' ') || centerSize
        
        lines.push(quantity + " " + item[0..lastSpaceIndex].ljust(centerSize) + " " + price)
        lines += getRemainder(item[(lastSpaceIndex + 1)..-1])
      else
        lines.push(quantity + " " + item + " " + price)
      end
    end
    
    if options != nil && !options.empty?
      lines.push("")
      
      if options.length > optionsSize
        lastSpaceIndex = options[0..(optionsSize - 1)].rindex(' ') || optionsSize
        
        lines.push("OPTIONS: " + options[0..lastSpaceIndex])
        lines += getRemainder(options[(lastSpaceIndex + 1)..-1])
      else
        lines.push("OPTIONS: " + options)
      end
    end
    
    if special_instructions != nil && !special_instructions.empty?      
      lines.push("")
      
      if special_instructions.length > instructionsSize
        lastSpaceIndex = special_instructions[0..(instructionsSize - 1)].rindex(' ') || (instructionsSize)
        
        lines.push("NOTES: " + special_instructions[0..lastSpaceIndex])
        lines += getRemainder(special_instructions[(lastSpaceIndex + 1)..-1])
      else
        lines.push("NOTES: " + special_instructions)
      end
    end
    
    return lines
  end
  

  def getRemainder(remainder)
    size = 27
    
    lines = []
    
    if remainder != nil && !remainder.empty?      
      if remainder.length > size - 1
        lastSpaceIndex = remainder[0..(size - 1)].rindex(' ') || size
        
        lines.push("    " + remainder[0..lastSpaceIndex])
        lines += getRemainder(remainder[(lastSpaceIndex + 1)..-1])
      else
        lines.push("    " + remainder)
      end
    end
    
    return lines
  end
  
  
  def getLeftRightLines(leftLines, rightLines)
    leftLength = leftLines.length
    rightLength = rightLines.length
    
    length = rightLength
    if (leftLength > rightLength)
      length = leftLength
    end
    
    lines = []
    
    for i in (0..(length - 1))
      line = ""
      
      if i < leftLength
        line += leftLines[i]
      else
        line += "".ljust(39)
      end
      
      line += "|"
      
      if i < rightLength
        line += rightLines[i]
      end
      
      lines.push(line)
    end
    
    return lines
  end
  
end