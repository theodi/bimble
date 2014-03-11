require 'spec_helper'

describe Bimble::Remote, :vcr do
  
  before :all do
    @remote = Bimble::Remote.new('Floppy', 'bimble-test', ENV['GITHUB_OAUTH_TOKEN'])
  end
  
  it "should be able to fetch the default branch for a repo" do
    @remote.default_branch.should == 'master'
  end

  it "should be able to get a blob sha for a file on a branch" do
    @remote.blob_sha('master', 'Gemfile').should == '971ea446b4dd814d3e1a59f2df9f52d911e60168'
  end

  it "should be able to get the content of the Gemfile blob" do
    content = @remote.blob_content('971ea446b4dd814d3e1a59f2df9f52d911e60168')
    content.should include('source "https://rubygems.org"')
    content.should include("gem 'rake'")
  end
  
  it "should be able to get the Gemfile in one call" do
    @remote.gemfile.should include('source "https://rubygems.org"')
  end
  
  # change the content somehow and post a new blob object with that new content, getting a blob SHA back
  # post a new tree object with that file path pointer replaced with your new blob SHA getting a tree SHA back
  # create a new commit object with the current commit SHA as the parent and the new tree SHA, getting a commit SHA back
  # update the reference of your branch to point to the new commit SHA
  
end