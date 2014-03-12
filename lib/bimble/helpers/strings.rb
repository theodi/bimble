module Bimble::Helpers::Strings
  
  def branch_name
    "update-dependencies-#{Date.today.to_s}"
  end

  def commit_message
    "automatically updated dependencies"
  end

  def pull_request_title
    "Updated dependencies"
  end
  
  def pull_request_body
    "Automatically updated by Bimble"
  end

end