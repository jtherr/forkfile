class LogoController < ApplicationController
  
  before_filter :check_for_restaurant
  
  def showLogo
    @restaurant = current_restaurant
    @logo = @restaurant.logo
    @title = @restaurant.name + ": Logo"
  end
  
  def changeLogo
    @title = "Change Logo"
  end
  
  
  def create
    @restaurant = current_restaurant
    
    if params['commit'] == "Cancel"
      redirect_to :action => 'showLogo'
      
    else
      @logo = @restaurant.logo
      
      if !@logo
        @logo = Logo.new(:restaurant_id => @restaurant.id)
        @logo.image_file = params[:logo][:image_file]
        @logo.save
      else
        @logo.update_attributes(params[:logo])
      end
      
      if @logo.errors.empty?
        redirect_to :action => 'showLogo'      
      else
        @title = "Change Logo"
        render :action => 'changeLogo'      
      end
      
    end
    
  end
  
  
  def delete
    logo = Logo.find(params[:id])

    logo_filename = "#{RAILS_ROOT}/public/images/restaurant_logos/#{logo.filename}"

    File.delete(logo_filename) if File.exist?(logo_filename)

    logo.destroy()

    redirect_to :action => 'showLogo'
  end
  
end
