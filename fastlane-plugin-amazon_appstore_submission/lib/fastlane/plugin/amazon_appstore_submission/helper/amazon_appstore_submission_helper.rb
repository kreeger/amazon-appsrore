# frozen_string_literal: true

require 'fastlane_core/ui/ui'

# The top-level Fastlane module.
module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?(:UI)

  module Helper
    # Handles interactions between Fastlane and AmazonAppstoreSubmission.
    class AmazonAppstoreSubmissionHelper
      # class methods that you define here become available in your action
      # as `Helper::AmazonAppstoreSubmissionHelper.your_method`
      #
      def self.show_message
        UI.message('Hello from the amazon_appstore_submission plugin helper!')
      end
    end
  end
end
