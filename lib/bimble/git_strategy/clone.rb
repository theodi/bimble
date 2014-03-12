require 'git'
require 'date'
require 'github_api'

class Bimble::GitStrategy::Clone

  def initialize(git_url, oauth_token)
    @github = Github.new oauth_token: oauth_token if oauth_token
    @git_url = git_url
  end

  def update(repo)
    Dir.mktmpdir do |tmpdir|
      repo = Git.clone(@git_url, tmpdir)
      Dir.chdir(tmpdir) do
        if File.exists?("Gemfile")
          `bundle update`
          branch = commit_to_new_branch(repo)
          open_pull_request(repo, branch) if branch
        end
      end
    end
  end

  def commit_to_new_branch(repo)
    if repo.status.changed.keys.include? "Gemfile.lock"
      branch = Bimble.branch_name
      repo.branch(branch).create
      repo.checkout(branch)
      repo.add("Gemfile.lock")
      repo.commit(Bimble.commit_message)  
      repo.push("origin", branch)
      branch
    else
      nil
    end
  end

  def open_pull_request(repo, branch)
    if @github
      matches = repo.remote("origin").url.match(/\A.+:(.+?)\/([^\.]+).*\Z/)
      if matches
        user, repo_name = matches[1], matches[2]
        @github.pull_requests.create user, repo_name,
                                     title: Bimble.pull_request_title,
                                     body:  Bimble.pull_request_body,
                                     head:  "#{user}:#{branch}",
                                     base:  "master"
      end
    end
  end

end