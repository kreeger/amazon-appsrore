# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe AmazonAppstoreSubmission do
  it 'has a version number' do
    expect(AmazonAppstoreSubmission::VERSION).not_to be nil
  end
end
