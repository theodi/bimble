require "bimble/helpers/github"

module Bimble
  
  def self.branch_name
    "update-dependencies-#{Date.today.to_s}"
  end

  def self.commit_message
    "automatically updated dependencies"
  end

  def self.pull_request_title
    "Updated dependencies"
  end
  
  def self.pull_request_body
    "Automatically updated by Bimble"
  end

end
