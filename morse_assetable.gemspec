# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'morse_assetable/version'

Gem::Specification.new do |spec|
  spec.name          = "morse_assetable"
  spec.version       = MorseAssetable::VERSION
  spec.authors       = ["Terry S", 'Fred Mac']
  spec.email         = ["itsterry@gmail.com", 'freddymcgroarty@gmail.com']
  spec.summary       = %q{ An easy way to handle submissions to carrierwave from a form }
  spec.description   = %q{ An easy way to handle submissions to carrierwave from a form }
  spec.homepage      = 'https://github.com/morsedigital/morse_assetable.git'
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
