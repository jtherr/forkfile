module MainHelper

  def getRandomForkImage
    image_id = rand(6)
    return "/images/fork_home/fork_home" + image_id.to_s + ".jpg"
  end

end
