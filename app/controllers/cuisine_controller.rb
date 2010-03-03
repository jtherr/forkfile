class CuisineController < ApplicationController
  
  before_filter :admin_required, :except => [ :browseCuisines ]
  
  def browseCuisines
    session[:search_terms][:keywords] = nil
    session[:search_terms][:favorites] = false
    session[:search_terms][:cuisine_id] = nil
    session[:search_terms][:order_type] = nil
    session[:search_terms][:viewingHistory] = false
    
    @restaurants = searchRestaurants()
    
    @cuisines = getCuisines(@restaurants)
    
    
    @title = "Cuisines"    
  end
  
  
  def showCuisines
    @cuisines = Cuisine.find(:all, :order => :name)
    @title = "Manage All Cuisines"    
  end
  
  def addCuisine
    @title = "Add Cuisine"
  end
  
  def editCuisine
    @cuisine = Cuisine.find(params[:id])
    session[:cuisine_id] = @cuisine.id
    @title = "Edit Cuisine"
  end
  
  
  def createCuisine
    @cuisine = Cuisine.new(params[:cuisine])
    
    if !@cuisine.save
      render :action => "addCuisine"
      flash[:notice] = "Error Creating Cuisine"
    else
      redirect_to :action => :showCuisines
    end
  end
  
  def updateCuisine
    @cuisine = Cuisine.find(session[:cuisine_id])
    if !@cuisine.update_attributes(params[:cuisine])
      render :action => "editCuisine"
      flash[:notice] = "Error Updating Cuisine"
    else
      redirect_to :action => :showCuisines
    end
  end
  
  def deleteCuisine
    @cuisine = Cuisine.find(params[:id])

    if @cuisine.destroy()
      redirect_to :action => :showCuisines
    else
      @cuisines = Cuisine.find(:all)
      render :action => "showCuisines"
      flash[:notice] = "Error Deleting Cuisine"
    end
  end
  
  
end