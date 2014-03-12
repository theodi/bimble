require 'base64'
require 'github_api'
require 'memoist'

module Bimble::Helpers::Github
  
  extend Memoist

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

  def create_blob(content)
    blob = @github.git_data.blobs.create @user, @repo, "content" => content, "encoding" => "utf-8"
    blob['sha']
  end

  def add_blob_to_tree(sha, filename)
    tree = tree default_branch
    new_tree = @github.git_data.trees.create @user, @repo, "base_tree" => tree['sha'], "tree" => [
      "path" => filename,
      "mode" => "100644",
      "type" => "blob",
      "sha" => sha
    ]
    new_tree['sha']
  end

  def commit(sha)
    parent = latest_commit(default_branch)
    commit = @github.git_data.commits.create @user, @repo, "message" => "updated dependencies",
              "parents" => [parent],
              "tree" => sha
    commit['sha']
  end
  
  def create_branch(name, sha)
    branch = @github.git_data.references.create @user, @repo, "ref" => "refs/heads/#{name}", "sha" => sha
    branch['ref']
  end

  def open_pr(head, base)
    @github.pull_requests.create @user, @repo,
      "title" => "Updated dependencies",
      "body" => "Automatically generated by bimble",
      "head" => head,
      "base" => base
  end
  
end