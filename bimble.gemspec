# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bimble/version'

Gem::Specification.new do |spec|
  spec.name          = "bimble"
  spec.version       = Bimble::VERSION
  spec.authors       = ["James Smith"]
  spec.email         = ["james@floppy.org.uk"]
  spec.description   = %q{Keep your bundles up to date}
  spec.summary       = %q{A gem and executable to check out a repo, run bundle update, then commit and open a PR}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'git'
  spec.add_dependency 'dotenv'
  spec.add_dependency 'github_api'
  spec.add_dependency 'launchy'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "travis"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"
  
end
