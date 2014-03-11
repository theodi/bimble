require 'spec_helper'

describe Bimble::Github, :vcr do
  
  before :all do
    @remote = Bimble::Github.new('Floppy', 'bimble-test', ENV['GITHUB_OAUTH_TOKEN'])
  end
  
  it "should be able to fetch the default branch for a repo" do
    @remote.default_branch.should == 'master'
  end
  
  it "should be able to get latest commit SHA on a branch" do
    @remote.latest_commit('master').should == '97376a25bcc2e403ed5b9c9f7eb35c0e8a36c01c'
  end

  it "should be able to get a blob sha for a file on a branch" do
    @remote.blob_sha('master', 'Gemfile').should == '971ea446b4dd814d3e1a59f2df9f52d911e60168'
  end

  it "should be able to get the content of the Gemfile blob" do
    content = @remote.blob_content('971ea446b4dd814d3e1a59f2df9f52d911e60168')
    content.should include('source "https://rubygems.org"')
    content.should include("gem 'rake'")
  end
  
  it "should be able to create a new blob" do
    blob_sha = @remote.create_blob('new blob content')
    blob_sha.should == '28b552e7359c5c3bbe947749aab70d18e3ea554b'
  end

  it "should be able to create a tree with the new blob in it given a filename" do
    # post a new tree object with that file path pointer replaced with your new blob SHA getting a tree SHA back
    tree_sha = @remote.add_blob_to_tree('28b552e7359c5c3bbe947749aab70d18e3ea554b', 'Gemfile.lock')
    tree_sha.should == 'e12209a3617bd2fd7a95755dc2808b75e239afa7'
  end
  
  it "should be able to create a new commit from a tree" do
    # create a new commit object with the current commit SHA as the parent and the new tree SHA, getting a commit SHA back
    commit_sha = @remote.commit('e12209a3617bd2fd7a95755dc2808b75e239afa7')
    commit_sha.should == 'fe6e5861c26a3a61c918b9b4bcc82059e4c0c62b'
  end
  
  it "should be able to create a new branch for a commit" do
    # update the reference of your branch to point to the new commit SHA
    branch = @remote.create_branch('update-dependencies', 'fe6e5861c26a3a61c918b9b4bcc82059e4c0c62b')
    branch.should == 'refs/heads/update-dependencies'
  end
  
  it "should be able to open a pull request back to the default branch" do
    pr = @remote.open_pr('update-dependencies', 'master')
    pr.number.should == 1
  end
  
  it "should be able to update Gemfile.lock and open PR all in one go" do
    content = @remote.get_file("Gemfile")
    pr = @remote.commit_file(content.reverse, "Gemfile.lock")
    pr.number.should == 2
  end
  
end