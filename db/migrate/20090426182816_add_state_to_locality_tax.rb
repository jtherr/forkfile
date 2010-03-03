class AddStateToLocalityTax < ActiveRecord::Migration
  def self.up
    add_column :locality_taxes, :state_id, :integer, :null => false
  end

  def self.down
    remove_column :locality_taxes, :state_id
  end
end
