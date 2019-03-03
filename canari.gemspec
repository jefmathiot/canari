# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'canari/version'

Gem::Specification.new do |spec|
  spec.name          = 'canari'
  spec.version       = Canari::VERSION
  spec.authors       = ['Jef Mathiot']
  spec.email         = ['jef@nonblocking.info']

  spec.summary       = 'A gem to monitor TLS certificates using Cert Stream.'
  spec.description   = 'A gem to monitor TLS certificates using Cert Stream.'
  spec.homepage      = 'https://github.com/jefmathiot/canari'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'coveralls', '~> 0.8', '>= 0.8.9'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'minitest-implicit-subject', '~> 1.4'
  spec.add_development_dependency 'rake', '~> 10.0'

  spec.add_dependency 'dalli', '~> 2.7'
  spec.add_dependency 'eventmachine', '~> 1.2'
  spec.add_dependency 'mail', '~> 2.7'
  spec.add_dependency 'permessage_deflate', '~> 0.1'
  spec.add_dependency 'thor', '~> 0.19'
  spec.add_dependency 'websocket-driver', '~> 0.7'
end
