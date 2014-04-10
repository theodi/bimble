module Bimble

  def self.bundle_update
    if File.exists?("Gemfile")
      `sh -c "bundle update"`
    end
  end

end
