module Bimble
  
  def self.create(strategy, options)
    case strategy
    when :clone
      Bimble::GitStrategy::Clone.new(options[:git_url], options[:github_oauth_token])
    when :github_api
      Bimble::GitStrategy::GithubApi.new(options[:git_url], options[:github_oauth_token])
    end
  end

end
