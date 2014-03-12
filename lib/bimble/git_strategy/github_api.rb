require 'github_api'

class Bimble::GitStrategy::GithubApi
  include Bimble::Helpers::Github
  
  def initialize(git_url, oauth_token)
    @github = Github.new oauth_token: oauth_token
    match = git_url.match /github.com[:\/]([^\/]*)\/([^\.]*)/
    if match 
      @user = match[1]
      @repo = match[2]
    end
  end

  def get_file(name)
    sha = blob_sha(default_branch, name)
    content = blob_content(sha)
  end
  
  def commit_file(name, content)    
    blob_sha = create_blob(content)
    tree_sha = add_blob_to_tree(blob_sha, name)
    commit_sha = commit(tree_sha)
    branch_name = "update-dependencies-#{Date.today.to_s}"
    create_branch(branch_name, commit_sha)
    open_pr(branch_name, default_branch)
  end

end