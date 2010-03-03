class SubOptionGroup < ActiveRecord::Base

  belongs_to :option_group
  belongs_to :option

  validates_uniqueness_of    :option_id, :scope => [:option_group_id]

  def validate
    if findLoop(self.option_id, self.option_group)
      errors.add_to_base("Cannot add this option group because it creates a loop")
    end
  end


  def findLoop(compare_option_id, option_group)
    option_group.options.each do |option|
      if compare_option_id == option.id
        return true
      else
        option.option_groups.each do |sub_option_group|
          return findLoop(compare_option_id, sub_option_group)
        end
      end
    end
    
    return false
  end


end
