[![Build Status](http://img.shields.io/travis/theodi/bimble.svg)](https://travis-ci.org/theodi/bimble)
[![Dependency Status](http://img.shields.io/gemnasium/theodi/bimble.svg)](https://gemnasium.com/theodi/bimble)
[![Coverage Status](http://img.shields.io/coveralls/theodi/bimble.svg)](https://coveralls.io/r/theodi/bimble)
[![Code Climate](http://img.shields.io/codeclimate/github/theodi/bimble.svg)](https://codeclimate.com/github/theodi/bimble)
[![Gem Version](http://img.shields.io/gem/v/bimble.svg)](https://rubygems.org/gems/bimble)
[![License](http://img.shields.io/:license-mit-blue.svg)](http://theodi.mit-license.org)
[![Badges](http://img.shields.io/:badges-7/7-ff6799.svg)](https://github.com/pikesley/badger)

# Bimble

A gem and executable to check out a repo, run bundle update, then commit and open a PR.
One more in a long line of robots to make our lives easier.

Oh, and it's called `bimble` because I sometimes misspell `bundle` that way.

## License

This code is open source under the MIT license. See the LICENSE.md file for 
full details.

## Installation

Add this line to your application's Gemfile:

    gem 'bimble'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bimble

## Usage

You need to be able to clone via SSH from the user the script will run as.

Then:

```
bimble git@github.com:{user}/{repo}.git
```

Once the bundle is updated, `Gemfile.lock` **only** will be committed on a new
branch called `update-dependencies-{date}`. If `GITHUB_OAUTH_TOKEN` is set in `.env`,
a pull request will be automatically opened (see below).

Currently, the best way to run it is probably to set up cron jobs to run the above
command for each of your repositories. The branch name has the date in, so it's probably
best not to run more than once a day. We make our [Jenkins](http://jenkins.theodi.org) 
build server run all ours once a week.

## Github OAuth Token

The following environment variables should be set in a `.env` file in order to use this app.

    GITHUB_OAUTH_TOKEN='your-oauth-token-for-your-app'
    
To generate this token, run `generate_github_oauth_token` and follow the instructions. You'll need
to be on a machine with a web browser.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
