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
      Bimble.bundle_update
      if lockfile_changed?
        commit_to_new_branch
        @pr = open_pr(branch_name, default_branch) if @oauth_token
      end
    end
    @pr ? @pr['html_url'] : nil
  end

  def in_working_copy
    Dir.mktmpdir do |tmpdir|
      @repository = Git.clone(@git_url, tmpdir)
      @default_branch = @repository.branch
      Dir.chdir(tmpdir) do
        yield
      end
    end
  end

  def lockfile_changed?
    @repository.status.changed.keys.include? "Gemfile.lock"
  end

  def commit_to_new_branch
    @repository.branch(branch_name).create
    @repository.checkout(branch_name)
    @repository.add("Gemfile.lock")
    @repository.commit(commit_message)  
    @repository.push("origin", branch_name)
  end

  def default_branch
    @default_branch
  end

end