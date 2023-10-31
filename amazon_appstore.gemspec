# frozen_string_literal: true

require_relative 'lib/amazon_appstore/version'

Gem::Specification.new do |spec|
  spec.name = 'amazon_appstore'
  spec.version = AmazonAppstore::VERSION
  spec.authors = ['Ben Kreeger']
  spec.email = ['ben@kree.gr']

  spec.summary = 'Provides a way to communicate with the Amazon Appstore Submission API.'
  spec.homepage = 'https://github.com/kreeger/amazon_appstore'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.6.0'

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/kreeger/amazon_appstore'
  spec.metadata['changelog_uri'] = 'https://raw.githubusercontent.com/kreeger/amazon_appstore/main/CHANGELOG.md'
  spec.metadata['rubygems_mfa_required'] = 'true'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency('multipart-post', '~> 2.0')

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
