class UpdateOrderToAllowNullUser < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE `orders` MODIFY COLUMN `user_id` INTEGER UNSIGNED;"
  end

  def self.down
    execute "ALTER TABLE `orders` MODIFY COLUMN `user_id` INTEGER UNSIGNED NOT NULL;"
  end
end
