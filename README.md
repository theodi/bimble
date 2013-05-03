bimble
======

A command-line script to check out a repo, run bundle update, then commit and open a PR.
One more in a long line of robots to make our lives easier.

Oh, and it's called `bimble` because I sometimes misspell `bundle` that way.

License
-------

This code is open source under the MIT license. See the LICENSE.md file for 
full details.

Use
---

You need to be able to clone via SSH from the user the script will run as.

Then:

```
./bimble.rb git@github.com:{user}/{repo}.git
```

Once the bundle is updated, `Gemfile.lock` **only** will be committed on a new
branch called `update-dependencies-{date}`. If `GITHUB_OAUTH_TOKEN` is set in `.env`,
a pull request will be automatically opened (see below).

Github OAuth Token
------------------

The following environment variables should be set in a .env file in order to use this app.

    GITHUB_OAUTH_TOKEN='your-oauth-token-for-your-app'
    
To generate this token, run `./generate_oauth_token.rb` and follow the instructions.