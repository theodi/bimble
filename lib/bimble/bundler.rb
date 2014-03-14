module Bimble
  
  def self.bundle_update
    if File.exists?("Gemfile")
      puts `bundle list`
    end
  end
  
end