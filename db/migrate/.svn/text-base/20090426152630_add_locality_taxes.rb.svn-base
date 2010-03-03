class AddLocalityTaxes < ActiveRecord::Migration
  def self.up
    create_table :locality_taxes do |t|
      t.string   :city_name, :null => true
      t.string   :county_name, :null => true
      t.decimal  :sales_tax, :precision => 8, :scale => 2, :null => true
      t.decimal  :food_tax, :precision => 8, :scale => 2, :null => true
    end
  end

  def self.down
    drop_table :locality_taxes
  end
end
