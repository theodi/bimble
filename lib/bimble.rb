module Bimble
  
  module Helpers
  end
  
  module GitStrategy
  end
  
end

require "bimble/version"
require "bimble/helpers/github"
require "bimble/helpers/strings"
require "bimble/helpers/updater"
require "bimble/git_strategy/clone"
require "bimble/git_strategy/github_api"
require "bimble/factory"
require "bimble/bundler"
