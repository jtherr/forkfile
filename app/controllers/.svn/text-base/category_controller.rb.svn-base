class CategoryController < ApplicationController
  
  before_filter :admin_required
  
  before_filter :check_for_restaurant
  
  def showCategories
    @restaurant = current_restaurant
    @categories = @restaurant.categories.find(:all, :order => 'position')
    @title = @restaurant.name + ": Categories"    
  end
  
  def addCategory
    @title = "Add Category"
  end
  
  def editCategory
    @category = Category.find(params[:id])
    session[:category_id] = @category.id
    @title = "Edit Category"
  end
  
  def reorderCategories
    @restaurant = current_restaurant
    @categories = @restaurant.categories.find(:all, :order => "position")
    @title = "Reorder Categories"
    render :partial => "reorderCategories"
  end
  
  def createCategory
    restaurant = current_restaurant
    max_position = restaurant.categories.maximum(:position) || 0
    
    @category = Category.new(params[:category])
    @category.restaurant_id = restaurant.id
    @category.position = max_position + 1
    
    if !@category.save
      render :action => "addCategory"
      flash[:notice] = "Error Creating Category"
    else
      redirect_to :action => :showCategories, :id => restaurant.id
    end
  end
  
  def updateCategory
    @category = Category.find(session[:category_id])
    if !@category.update_attributes(params[:category])
      render :action => "editCategory"
      flash[:notice] = "Error Updating Category"
    else
      redirect_to :action => :showCategories, :id => current_restaurant.id
    end
  end
  
  def deleteCategory
    @category = Category.find(params[:id])

    if @category.destroy()
      redirect_to :action => :showCategories, :id => current_restaurant.id
    else
      @restaurant = current_restaurant
      @categories = Category.find(:all, :conditions => "restaurant_id = #{@restaurant.id}")
      render :action => "showCategories"
      flash[:notice] = "Error Deleting Category"
    end
  end
  
  def updateOrder
    params[:categoryList].each_with_index do |id, position|
      Category.update(id, :position => position)
    end
    render :nothing => true
  end

end