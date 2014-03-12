require 'git'

class Bimble::GitStrategy::Clone

  include Bimble::Helpers::Github

  def initialize(git_url, oauth_token)
    @git_url = git_url
    @oauth_token = oauth_token
  end

  def update
    Dir.mktmpdir do |tmpdir|
      repository = Git.clone(@git_url, tmpdir)
      Dir.chdir(tmpdir) do
        if File.exists?("Gemfile")
          `bundle update`
          branch = commit_to_new_branch(repository)
          open_pr(branch, "master") if branch
        end
      end
    end
  end

  def commit_to_new_branch(repository)
    if repository.status.changed.keys.include? "Gemfile.lock"
      branch = Bimble.branch_name
      repository.branch(branch).create
      repository.checkout(branch)
      repository.add("Gemfile.lock")
      repository.commit(Bimble.commit_message)  
      repository.push("origin", branch)
      branch
    else
      nil
    end
  end

end