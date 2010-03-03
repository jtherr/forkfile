class MoveLogosToFiles < ActiveRecord::Migration
  def self.up
    remove_column :restaurants, :logo
  
    Logo.find(:all).each do |logo|
  
      original_filename = logo.filename
      last_dot_index = original_filename.rindex(".")
      
      extension = ".jpg"
      if last_dot_index != nil
        extension = original_filename[last_dot_index..-1]
      end
      
      new_filename =  logo.restaurant_id.to_s + extension
      directory = "public/images/restaurant_logos"
      # create the file path
      path = File.join(directory, new_filename)
            
      # write the file
      File.open(path, "wb") { |f| f.write(logo.picture) }
      logo.filename = new_filename
      logo.save
    end
  
    remove_column :logos, :picture
  end

  def self.down    
    add_column :restaurants, :logo, :blob, :null => true
    add_column :logos, :picture, :blob, :null => false
  end
end
