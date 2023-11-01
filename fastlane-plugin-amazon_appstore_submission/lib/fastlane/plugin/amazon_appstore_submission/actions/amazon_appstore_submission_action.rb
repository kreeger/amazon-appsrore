# frozen_string_literal: true

require 'fastlane/action'
require_relative '../helper/amazon_appstore_submission_helper'

module Fastlane
  module Actions
    # Dictates what is offered by the AmazonAppstoreSubmission plugin for Fastlane.
    class AmazonAppstoreSubmissionAction < Action
      def self.run(_params)
        UI.message('The amazon_appstore_submission plugin is working!')
      end

      def self.description
        'Provides a way to communicate with the Amazon Appstore Submission API.'
      end

      def self.authors
        ['Ben Kreeger']
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        'Provides a way to communicate with the Amazon Appstore App Submission ' \
          'API for creating new versions, uploading APKs, and more.'
      end

      def self.available_options
        [
          # FastlaneCore::ConfigItem.new(key: :your_option,
          #                         env_name: "AMAZON_APPSTORE_SUBMISSION_YOUR_OPTION",
          #                      description: "A description of your option",
          #                         optional: false,
          #                             type: String)
        ]
      end

      # rubocop:disable Naming/PredicateName
      def self.is_supported?(_platform)
        # rubocop:enable Naming/PredicateName
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end
    end
  end
end
