# frozen_string_literal: true

require 'fastlane/plugin/amazon_appstore_submission/version'

# The top-level Fastlane module.
module Fastlane
  # Contains code for the AmazonAppstoreSubmission plugin for Fastlane.
  module AmazonAppstoreSubmission
    # Return all .rb files inside the "actions" and "helper" directory
    def self.all_classes
      Dir[File.expand_path('**/{actions,helper}/*.rb', File.dirname(__FILE__))]
    end
  end
end

# By default we want to import all available actions and helpers
# A plugin can contain any number of actions and plugins
Fastlane::AmazonAppstoreSubmission.all_classes.each do |current|
  require current
end
