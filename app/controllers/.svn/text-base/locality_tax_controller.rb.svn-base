class LocalityTaxController < ApplicationController
  
  before_filter :admin_required
  
  
  def showTaxes
    @locality_taxes = LocalityTax.find(:all)
    
    @title = "Locality Taxes"
  end
  
  def addLocalityTax
    @states = State.find(:all)
    @title = "Add Locality Tax"
    render :partial => "addLocalityTax"
  end
  
  def editLocalityTax
    @locality_tax = LocalityTax.find(params[:id])
    @states = State.find(:all)
    @title = "Edit Locality Tax"
    render :partial => "editLocalityTax"
  end


  
  
  def createLocalityTax  
    @locality_tax = LocalityTax.new(params[:locality_tax])
    
    if @locality_tax.save
      @locality_taxes = LocalityTax.find(:all)
      render :partial => 'localityTaxes'
    else
      @states = State.find(:all)
      @title = "Add Locality Tax"
      render :partial => 'addLocalityTax', :status => 444
    end
    
  end

  def updateLocalityTax  
    @locality_tax = LocalityTax.find(params[:id])
    
    if @locality_tax.update_attributes(params[:locality_tax])
      @locality_taxes = LocalityTax.find(:all)
      render :partial => 'localityTaxes'
    else
      @states = State.find(:all)
      @title = "Edit Locality Tax"
      render :partial => 'editLocalityTaxes', :status => 444
    end
  end
  
  
  def deleteLocalityTax
    locality_tax = LocalityTax.find(params[:id])
    locality_tax.destroy()
    
    @locality_taxes = LocalityTax.find(:all)
    render :partial => 'localityTaxes'
  end


end