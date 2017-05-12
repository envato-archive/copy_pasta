# coding: utf-8

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "unthread/version"

Gem::Specification.new do |spec|
  spec.name          = "unthread"
  spec.version       = Unthread::VERSION
  spec.authors       = ["Justin Mazzi"]
  spec.email         = ["justin@pressed.net"]

  spec.summary       = "Utility for unpacking tar files concurrently"
  spec.description   = "Utility for unpacking tar files concurrently"
  spec.homepage      = "https://pressed.net"

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "reek", "~> 4.6"
  spec.add_development_dependency "rubocop", "~> 0.48"
  spec.add_development_dependency "rubocop-rspec", "~> 1.15"

  spec.add_dependency "minitar-jmazzi", "0.5.4"
  spec.add_dependency "concurrent-ruby", "~> 1.0"
end
