module Bimble

  def self.bundle_update
    if File.exists?("Gemfile")
      Bundler.with_clean_env do
        `sh -c "bundle update"`
      end
    end
  end

end
