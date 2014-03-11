require 'spec_helper'

describe Bimble::Remote, :vcr do
  
  before :all do
    @remote = Bimble::Remote.new('Floppy', 'bimble-test', ENV['GITHUB_OAUTH_TOKEN'])
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
  
  it "should be able to get the Gemfile in one call" do
    @remote.gemfile.should include('source "https://rubygems.org"')
  end
  
  it "should be able to create a new blob" do
    blob = @remote.create_blob(@remote.gemfile + 'parp')
    blob['sha'].should == '2f887b9646727c6d09043c99980fbd7dcb04d9d6'
  end
  
end