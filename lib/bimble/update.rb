module Bimble
  
  def self.update(dir)
    Dir.chdir(dir) do
      if File.exists?("Gemfile")
        `bundle update`
      end
    end
  end
  
end