#!/usr/bin/env ruby

require 'dotenv'
require 'bimble'

Dotenv.load

bimble = Bimble::Runner.new(ENV['GITHUB_OAUTH_TOKEN'])
bimble.update(ARGV[0])