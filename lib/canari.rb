# frozen_string_literal: true

require 'canari/version'
require 'canari/cert_stream'
require 'canari/domain_cache'
require 'canari/notifier'

module Canari
  def self.version
    VERSION
  end
end
