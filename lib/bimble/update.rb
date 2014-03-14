module Bimble
  
  def self.update
    if File.exists?("Gemfile")
      `bundle update`
    end
  end
  
end