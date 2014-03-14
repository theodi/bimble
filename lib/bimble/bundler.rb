module Bimble
  
  def self.bundle_update
    if File.exists?("Gemfile")
      `bundle update`
    end
  end
  
end