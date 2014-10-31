# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = 'kitchen-binding'
  gem.version       = '0.2.0'
  gem.license       = 'Apache 2.0'
  gem.authors       = ['Jacob McCann']
  gem.email         = ['jmcann.git@gmail.com']
  gem.description   = 'Test Kitchen extension for remote ruby shells'
  gem.summary       = gem.description
  gem.homepage      = 'https://github.com/jmccann/kitchen-binding/'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = []
  gem.require_paths = ['lib']

  gem.add_dependency 'test-kitchen', '~> 1.2.1'
  gem.add_dependency 'pry-remote', '~> 0.1.8'
end
