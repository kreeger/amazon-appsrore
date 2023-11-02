# frozen_string_literal: true

require_relative 'spec_helper'

describe Fastlane::Actions::AmazonAppstoreSubmissionAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with('The amazon_appstore_submission plugin is working!')

      Fastlane::Actions::AmazonAppstoreSubmissionAction.run(nil)
    end
  end
end
