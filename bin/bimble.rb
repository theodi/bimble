#!/usr/bin/env ruby

require 'git'
require 'date'
require 'dotenv'
require 'github_api'

Dotenv.load

def do_update(repo)
  if File.exists?("Gemfile")
    `bundle update`
    branch = commit_to_new_branch(repo)
    open_pull_request(repo, branch) if branch
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
  if ENV['GITHUB_OAUTH_TOKEN']
    github = Github.new oauth_token: ENV['GITHUB_OAUTH_TOKEN']

    matches = repo.remote("origin").url.match(/\A.+:(.+?)\/([^\.]+).*\Z/)
    if matches
      user, repo_name = matches[1], matches[2]
      github.pull_requests.create user, repo_name,
                                  title: "automatically updated dependencies",
                                  head: "#{user}:#{branch}",
                                  base: "master"
    end
  end
end

Dir.mktmpdir do |tmpdir|
  repo = Git.clone(ARGV[0], tmpdir)
  Dir.chdir(tmpdir) do
    do_update(repo)
  end
end