# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pikmv/version'

Gem::Specification.new do |spec|
  spec.name          = "pikmv"
  spec.version       = Pikmv::VERSION
  spec.authors       = ["zhon"]
  spec.email         = ["zhon@xmission.com"]

  spec.summary       = %q{Tools for handling image files.}
  spec.description   = %q{}
  spec.homepage      = "http://github.com/zhon/pikmv"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "exif", "~> 1.0"
  spec.add_runtime_dependency "chronic", "~> 0.10"

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "guard", "~> 2.14"
  spec.add_development_dependency "guard-minitest", "~> 2.4"
end
