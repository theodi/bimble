class Bimble::GitStrategy::GithubApi
  
  include Bimble::Helpers::Strings
  include Bimble::Helpers::Github
  
  def initialize(git_url, oauth_token)
    @git_url = git_url
    @oauth_token = oauth_token
  end

  def get_files(name)
    blobs = blob_shas(default_branch, name)
    Hash[blobs.map{|x| [x[0], blob_content(x[1])]}]
  end
  
  def get_file(name)
    get_files(name)[name]
  end
  
  def commit_file(name, content)    
    blob_sha = create_blob(content)
    tree_sha = add_blob_to_tree(blob_sha, name)
    commit_sha = commit(tree_sha)
    create_branch(branch_name, commit_sha)
    open_pr(branch_name, default_branch)
  end

end