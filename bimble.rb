#!/usr/bin/env ruby

require 'git'
require 'date'
require 'dotenv'

Dotenv.load

git_url = ARGV[0]

repo = Git.clone(git_url, 'clone')

Dir.chdir('clone') do |path|
  
  if File.exists?("Gemfile")
  
    `bundle update`
  
    if repo.status.changed.keys.include? "Gemfile.lock"
      branch = "update-dependencies-#{Date.today.to_s}"
      repo.branch(branch).create
      repo.checkout(branch)
      repo.add("Gemfile.lock")
      repo.commit("automatically updated dependencies")  
      repo.push("origin", branch)
    end
    
  end
  
end

FileUtils.rm_rf("clone")