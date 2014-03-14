require 'git'

class Bimble::GitStrategy::Clone

  include Bimble::Helpers::Strings
  include Bimble::Helpers::Github

  def initialize(git_url, oauth_token)
    @git_url = git_url
    @oauth_token = oauth_token
  end

  def update
    Dir.mktmpdir do |tmpdir|
      repository = Git.clone(@git_url, tmpdir)
      Bimble.update(tmpdir)
      if repository.status.changed.keys.include? "Gemfile.lock"
        branch = commit_to_new_branch(repository)
        open_pr(branch, "master")
      end
    end
  end

  private

  def commit_to_new_branch(repository)
    repository.branch(branch_name).create
    repository.checkout(branch_name)
    repository.add("Gemfile.lock")
    repository.commit(commit_message)  
    repository.push("origin", branch_name)
    branch_name
  end

end