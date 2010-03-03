class AddContractSignedIndicator < ActiveRecord::Migration
  def self.up
    add_column :restaurants, :contract_signed, :boolean
    add_column :restaurant_versions, :contract_signed, :boolean
  end

  def self.down
    remove_column :restaurants, :contract_signed
    remove_column :restaurant_versions, :contract_signed
  end
end
