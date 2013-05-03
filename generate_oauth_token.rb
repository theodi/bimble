#!/usr/bin/env ruby

require 'launchy'
require 'github_api'

puts <<EOF
First, we will create a new Github application. 
If you want put it in an organization, change to that section of the settings page first.
If you already have an application, just skip this part.
For the callback URL, you can just enter 'http://example.iana.org/'
Hit enter to open a browser and create your application.
EOF
gets

Launchy.open "https://github.com/settings/applications/new"

print "Enter the client ID: "
client_id = gets.strip

print "Enter the client secret: "
client_secret = gets.strip

github = Github.new :client_id => client_id, :client_secret => client_secret
auth_url = github.authorize_url :redirect_uri => 'http://example.iana.org/', :scope => 'repo'

Launchy.open auth_url

print "Authorize the app, then paste the URL of the page Github redirected you to: "
token_url = gets.strip

token = github.get_token(token_url.split('=').last)

print <<EOF  
Your OAuth token is #{token.token}. 
If you want me to write this to .env for you, enter 'overwrite' (warning, .env will be overwritten): 
EOF
response = gets.strip

if response == 'overwrite'
  puts 'OK, overwriting .env'
  File.write '.env', "GITHUB_OAUTH_TOKEN='#{token.token}'"
else
  puts 'OK, skipping .env'
end

puts 'All done, you should be good to go.'