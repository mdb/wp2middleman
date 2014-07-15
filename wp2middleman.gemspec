# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wp2middleman/version'

Gem::Specification.new do |spec|
  spec.name          = "wp2middleman"
  spec.version       = WP2Middleman::VERSION
  spec.authors       = ["Mike Ball"]
  spec.email         = ["mikedball@gmail.com"]
  spec.description   = %q{Migrate a Wordpress export XML file to Middleman-style markdown files}
  spec.summary       = %q{Migrate Wordpress blog posts to Middleman-style markdown files}
  spec.homepage      = "http://github.com/mdb/wp2middleman"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "nokogiri"
  spec.add_dependency "html2markdown"
  spec.add_dependency "thor"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "simplecov"
end
