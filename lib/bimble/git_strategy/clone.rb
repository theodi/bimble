require 'git'

class Bimble::GitStrategy::Clone

  include Bimble::Helpers::Strings
  include Bimble::Helpers::Github

  def initialize(git_url, oauth_token)
    @git_url = git_url
    @oauth_token = oauth_token
  end

  def update
    in_working_copy do
      Bimble.update
      if lockfile_changed?
        branch = commit_to_new_branch
        open_pr(branch, "master") if @oauth_token
      end
    end
  end

  def in_working_copy
    Dir.mktmpdir do |tmpdir|
      @repository = Git.clone(@git_url, tmpdir)
      Dir.chdir(tmpdir) do
        yield
      end
    end
  end

  private

  def lockfile_changed?
    @repository.status.changed.keys.include? "Gemfile.lock"
  end

  def commit_to_new_branch
    @repository.branch(branch_name).create
    @repository.checkout(branch_name)
    @repository.add("Gemfile.lock")
    @repository.commit(commit_message)  
    @repository.push("origin", branch_name)
    branch_name
  end

end