module Bimble

  def self.bundle_update
    if File.exists?("Gemfile")
      Bundler.with_clean_env do
        puts `sh -c "BUNDLE_IGNORE_CONFIG=true bundle update"`
      end
    end
  end

end
