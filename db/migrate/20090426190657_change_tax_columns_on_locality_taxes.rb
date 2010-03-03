class ChangeTaxColumnsOnLocalityTaxes < ActiveRecord::Migration
  def self.up
    remove_column :locality_taxes, :sales_tax
    rename_column :locality_taxes, :food_tax, :meal_tax
  end

  def self.down
    add_column :locality_taxes, :sales_tax, :integer, :precision => 8, :scale => 2, :null => true
    rename_column :locality_taxes, :meal_tax, :food_tax
  end
end
