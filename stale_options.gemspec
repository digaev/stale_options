
lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'stale_options/version'

Gem::Specification.new do |spec|
  spec.name          = 'stale_options'
  spec.version       = StaleOptions::VERSION
  spec.authors       = ['Nikolay Digaev']
  spec.email         = ['ffs.cmp@gmail.com']

  spec.summary       = 'A gem for caching HTTP responses'
  spec.homepage      = 'https://github.com/digaev/stale_options'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.require_paths = ['lib']

  spec.add_dependency 'activerecord', '>= 5.0', '< 6.0'
  spec.add_dependency 'activesupport', '>= 5.0', '< 6.0'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'coveralls', '~> 0.8'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'sqlite3', '~> 1.3'
end
