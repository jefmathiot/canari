# frozen_string_literal: true

require 'thor'
require 'canari'
require 'eventmachine'
require 'net/http'
require 'uri'
require 'logger'
require 'yaml'
require 'dalli'

module Canari
  # Command-line interface.
  class CLI < Thor
    desc 'start', 'Start monitoring TLS certificates'
    method_option :config, aliases: %i[c], default: 'canari.yml'
    method_option :domains, aliases: %i[d], default: 'domains.txt'
    def start
      Canari.load_config(options[:config])
      DomainCache.preload(options[:domains])
      run(URI.parse('wss://certstream.calidog.io'))
      loop do
        sleep 1
      end
    end

    def run(uri)
      EM.run do
        EM.connect(uri.host, 443, CertStream) do |stream|
          stream.url = uri.to_s
          stream.start_tls(sni_hostname: uri.host)
        end
      end
    end
  end

  def self.logger
    @logger ||= Logger.new(STDOUT)
  end

  def self.load_config(file)
    config = @config = YAML.safe_load(
      File.open(File.expand_path(file)), [Symbol]
    )
    Mail.defaults do
      delivery_method :smtp, config[:smtp]
    end
  end

  def self.config
    @config
  end
end
