# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
    
  def loadingBlock(&block)
    concat('<div class="loading">', block.binding)
    concat('  <div class="loading_image"><input type="image" src="/images/loading.gif"></div>', block.binding)
    concat('  <div class="loading_label">', block.binding)
    
    yield
    
    concat('  </div>', block.binding)
    concat('</div>', block.binding)
  end
  
  def shadowBox(title, &block)
    concat("<div class='shadowBox'>", block.binding)
    concat("  <div class='front'>", block.binding)
    
    concat("    <div class='topLeft'></div>", block.binding)
    concat("    <div class='topRight'></div>", block.binding)

    concat("    <div class='content'>", block.binding)
    
    if title
      concat("    <div class='title'>#{title}</div>", block.binding)
    end
    
    yield

    concat('    </div>', block.binding)
        
    concat("    <div class='bottomLeft'></div>", block.binding)
    concat("    <div class='bottomRight'></div>", block.binding)
    
    concat('  </div>', block.binding)
    concat('</div>', block.binding)
  end
  
  
  
  def roundedBoxWhite(title, &block)
    concat("<div class='roundedBox'>", block.binding)
    concat("  <div class='whiteTopLeft'></div>", block.binding)
    concat("  <div class='whiteTopRight'></div>", block.binding)

    concat("  <div class='content'>", block.binding)
    
    if title
      concat("  <div class='title'>#{title}</div>", block.binding)
    end
    
    yield
    concat('  </div>', block.binding)
    
    concat("  <div class='whiteBottomLeft'></div>", block.binding)
    concat("  <div class='whiteBottomRight'></div>", block.binding)
    concat('</div>', block.binding)
  end
  
  
  def roundedBoxPopup(title, &block)
    concat("<div class='popupBox'>", block.binding)
    concat("  <div class='top'>", block.binding)
    concat("    <div class='left'></div>", block.binding)
    concat("    <div class='middle'>&nbsp;</div>", block.binding)
    concat("    <div class='right'></div>", block.binding)
    concat("  </div>", block.binding)

    
    concat("  <div class='back'>", block.binding)
    concat("    <div class='content'>", block.binding)
    
    if title
      concat("    <div class='title'>#{title}</div>", block.binding)
    end
    
    yield
    concat('    </div>', block.binding)
    concat('  </div>', block.binding)
    
    concat("  <div class='bottom'>", block.binding)
    concat("    <div class='left'></div>", block.binding)
    concat("    <div class='middle'>", block.binding)
    concat("      <div class='top'>&nbsp;</div>", block.binding)
    concat("      <div class='bottom'>&nbsp;</div>", block.binding)
    concat("    </div>", block.binding)
    concat("    <div class='right'></div>", block.binding)
    concat("  </div>", block.binding)

    concat('</div>', block.binding)
  end


  def roundedMainNavBarWhite(&block)
    concat("<div class='roundedBox mainNav'>", block.binding)
    concat("  <div class='mainNavLeft'></div>", block.binding)

    concat("  <div class='content'>", block.binding)
    yield
    concat('  </div>', block.binding)
    
    concat("  <div class='mainNavRight'></div>", block.binding)
    concat('</div>', block.binding)
  end



  def roundedSubNavBarWhite(&block)
    concat("<div class='roundedBox subNav'>", block.binding)
    concat("  <div class='subNavLeft'></div>", block.binding)

    concat("  <div class='content'>", block.binding)
    yield
    concat('  </div>', block.binding)
    
    concat("  <div class='subNavRight'></div>", block.binding)
    concat('</div>', block.binding)
  end
  

  def roundedMessageBarWhite(&block)
    concat("<div class='roundedBox statusMsg'>", block.binding)
    concat("  <div class='subNavLeft'></div>", block.binding)

    concat("  <div class='content'>", block.binding)
    yield
    concat('  </div>', block.binding)
    
    concat("  <div class='subNavRight'></div>", block.binding)
    concat('</div>', block.binding)
  end
  
  
  def primaryButton(&block)
    concat("<div class='primaryButton'>", block.binding)
    concat("  <div class='buttonLeft'></div>", block.binding)
    yield
    concat("  <div class='buttonRight'></div>", block.binding)
    concat('</div>', block.binding)
  end

  def secondaryButton(&block)
    concat("<div class='secondaryButton'>", block.binding)
    concat("  <div class='buttonLeft'></div>", block.binding)
    yield
    concat("  <div class='buttonRight'></div>", block.binding)
    concat('</div>', block.binding)
  end

  def primaryButtonSmall(&block)
    concat("<div class='primaryButtonSmall'>", block.binding)
    concat("  <div class='buttonLeft'></div>", block.binding)
    yield
    concat("  <div class='buttonRight'></div>", block.binding)
    concat('</div>', block.binding)
  end

  def secondaryButtonSmall(&block)
    concat("<div class='secondaryButtonSmall'>", block.binding)
    concat("  <div class='buttonLeft'></div>", block.binding)
    yield
    concat("  <div class='buttonRight'></div>", block.binding)
    concat('</div>', block.binding)
  end


  def abbreviate(value, length)
    if value != nil && value.length > length
      value = value[0..(length - 3)] + "..."
    end
  
    return value
  end
  
  def isRestaurantsTabSelected() 
    if @isRestaurantView || @isBrowseView
      return "selected"
    end
    
    return ""
  end

  def isSpecialsTabSelected() 
    if @isSpecialsView
      return "selected"
    end

    return ""
  end
  
  def isFavoritesTabSelected()
    if @isFavoritesView
      return "selected"
    end
    
    return ""
  end
  
  def isRecentOrdersTabSelected()
    if @isRecentOrdersView
      return "selected"
    end
    
    return ""
  end
    

  def getStep(current_number, this_number, text, controller, action)
    this_class = ""
    
    if current_number == this_number
      this_class = " current"
    elsif current_number > this_number
      this_class = " completed"
    end
    
    return_text = '<div class="step' + this_class + '"><div class="number">' + this_number.to_s + '</div><div class="name">' + text + '</div></div>'
    
    if current_number >= this_number
      return_text = '<a href="/' + controller + '/' + action + '">' + return_text + '</a>'
    end
    
    return return_text
  end


end
