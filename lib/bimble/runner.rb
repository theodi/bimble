require 'git'
require 'date'
require 'github_api'

class Bimble::Runner

  def initialize(oauth_token)
    @github = Github.new oauth_token: oauth_token
  end

  def update(repo)
    Dir.mktmpdir do |tmpdir|
      repo = Git.clone(ARGV[0], tmpdir)
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
      branch = "update-dependencies-#{Date.today.to_s}"
      repo.branch(branch).create
      repo.checkout(branch)
      repo.add("Gemfile.lock")
      repo.commit("automatically updated dependencies")  
      repo.push("origin", branch)
      branch
    else
      nil
    end
  end

  def open_pull_request(repo, branch)
    matches = repo.remote("origin").url.match(/\A.+:(.+?)\/([^\.]+).*\Z/)
    if matches
      user, repo_name = matches[1], matches[2]
      @github.pull_requests.create user, repo_name,
                                   title: "automatically updated dependencies",
                                   head: "#{user}:#{branch}",
                                   base: "master"
    end
  end

end