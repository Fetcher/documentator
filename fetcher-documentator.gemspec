# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fetcher-documentator/version'

Gem::Specification.new do |gem|
  gem.name          = "fetcher-documentator"
  gem.version       = Fetcher::Documentator::VERSION
  gem.authors       = ["Luciano Bertenasco", "Xavier Via"]
  gem.email         = ["lbertenasco@gmail.com", "fernando.via@gmail.com"]
  gem.description   = %q{A documentator gem for Fetcher}
  gem.summary       = %q{A documentator gem for Fetcher}
  gem.homepage      = "https://github.com/Fetcher/documentator"

  gem.add_dependency 'fast'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
