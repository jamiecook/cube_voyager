# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cube_voyager/version'

Gem::Specification.new do |spec|
  spec.name          = "cube_voyager"
  spec.version       = CubeVoyager::VERSION
  spec.authors       = ["Jamie Cook"]
  spec.email         = ["jamie@ieee.org"]
  spec.description   = %q{A gem for reading cube voyager matrices (http://www.citilabs.com/products/cube/cube-voyager)}
  spec.summary       = %q{Cube Voyager matrix I/O}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
