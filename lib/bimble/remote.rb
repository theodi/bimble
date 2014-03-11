require 'base64'
require 'github_api'
require 'memoist'

class Bimble::Remote
  extend Memoist
  
  def initialize(user, repo, oauth_token)
    @github = Github.new oauth_token: oauth_token
    @user = user
    @repo = repo
  end

  def default_branch
    repo = @github.repos.get @user, @repo
    repo.default_branch
  end
  memoize :default_branch

  def latest_commit(branch_name)
    branch_data = @github.repos.branch @user, @repo, branch_name
    branch_data['commit']['sha']
  end
  memoize :latest_commit

  def tree(branch)
    @github.git_data.trees.get @user, @repo, branch
  end

  def blob_sha(branch, path)
    tree = tree branch
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
    blob = @github.git_data.blobs.create @user, @repo, "content" => content, "encoding" => "utf-8"
    blob['sha']
  end

  def add_blob_to_tree(sha, filename)
    tree = tree default_branch
    new_tree = @github.git_data.trees.create @user, @repo, "base_tree" => tree['sha'], "tree" => [
      "path" => "Gemfile.lock",
      "mode" => "100644",
      "type" => "blob",
      "sha" => sha
    ]
    new_tree['sha']
  end

end