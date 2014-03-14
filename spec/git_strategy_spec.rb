require 'spec_helper'

[
  #:clone,
  :github_api,
].each do |strategy|

  describe "#{strategy} strategy", :vcr do
    
    before :all do
      @bimble = Bimble.create(strategy, 
                              git_url: 'git@github.com:Floppy/bimble-test.git', 
                              github_oauth_token: ENV['GITHUB_OAUTH_TOKEN'])
    end
    
    it "should get all appropriate files" do
      @bimble.in_working_copy do
        File.exists?('Gemfile').should be_true
        File.exists?('Gemfile.lock').should be_true
        File.exists?('bimble-test.gemspec').should be_true
      end
    end
  
  end
  
end