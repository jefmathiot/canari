# frozen_string_literal: true

require 'spec_helper'

describe Canari do
  it 'provides the version' do
    subject.version.must_equal Canari::VERSION
  end
end
