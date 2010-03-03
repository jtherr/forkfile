class Logo < ActiveRecord::Base
  belongs_to :restaurant
  
  def image_file=(input_data)
    if input_data != ""
      original_filename = input_data.original_filename
      last_dot_index = original_filename.rindex(".")
      extension = original_filename[last_dot_index..-1]
      
      new_filename =  self.restaurant_id.to_s + extension
      directory = "public/images/restaurant_logos"
      # create the file path
      path = File.join(directory, new_filename)
      
      picture = input_data.read
      
      if !picture
        errors.add_to_base "Filename is required"
      elsif picture.length > 25600
        errors.add_to_base "Logo must not be larger than 25 KB"
      else
        # write the file
        File.open(path, "wb") { |f| f.write(picture) }
        
        self.filename = new_filename
        self.content_type = input_data.content_type.chomp
      end
    end
  end
  
end
