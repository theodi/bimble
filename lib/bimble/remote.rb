require 'base64'
require 'github_api'

class Bimble::Remote

  def initialize(user, repo, oauth_token)
    @github = Github.new oauth_token: oauth_token
    @user = user
    @repo = repo
  end

  def default_branch
    repo = @github.repos.get @user, @repo
    repo.default_branch
  end

  def blob_sha(branch, path)
    tree = @github.git_data.trees.get @user, @repo, branch
    tree['tree'].find{|x| x['path'] == path && x['type'] == 'blob'}.sha rescue nil
  end
  
  def blob_content(sha)
    blob = @github.git_data.blobs.get @user, @repo, sha
    if blob['encoding'] == 'base64'
      Base64.decode64(blob['content'])
    else
      blob['content']
    end
  end

  def gemfile
    sha = blob_sha(default_branch, "Gemfile")
    blob_content(sha)
  end

  def create_blob(content)
    @github.git_data.blobs.create @user, @repo, "content" => content, "encoding" => "utf-8"
  end

end