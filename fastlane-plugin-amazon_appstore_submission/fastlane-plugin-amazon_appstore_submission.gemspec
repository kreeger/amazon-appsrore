# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/amazon_appstore_submission/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-amazon_appstore_submission'
  spec.version       = Fastlane::AmazonAppstoreSubmission::VERSION
  spec.author        = 'Ben Kreeger'
  spec.email         = 'ben@kree.gr'

  spec.summary       = 'Provides a way to communicate with the Amazon Appstore Submission API.'
  spec.homepage      = 'https://github.com/kreeger/amazon_appstore_submission'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*'] + %w[README.md LICENSE]
  spec.require_paths = ['lib']
  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.required_ruby_version = '>= 2.6'

  # Don't add a dependency to fastlane or fastlane_re
  # since this would cause a circular dependency

  spec.add_dependency 'amazon_appstore_submission', '0.1.0'
end
