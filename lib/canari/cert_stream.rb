# frozen_string_literal: true

require 'websocket/driver'
require 'permessage_deflate'
require 'json'
require 'uri'

module Canari
  module CertStream
    attr_accessor :url

    def connection_completed
      @driver = WebSocket::Driver.client(self)
      @driver.add_extension(PermessageDeflate)
      attach_listeners
      @driver.start
    end

    def receive_data(data)
      @driver.parse(data)
    end

    def write(data)
      send_data(data)
    end

    def finalize(event)
      Canari.logger.info "Connection closed, #{event.code}: #{event.reason}"
      close_connection
      Canari.logger.info 'Reconnecting'
      reconnect(uri.host, 443)
    end

    def uri
      URI.parse(url)
    end

    def attach_listeners
      @driver.on(:open)    { |_event| Canari.logger.info 'Connection open' }
      @driver.on(:message) do |event|
        handle_message(event.data)
      end
      @driver.on(:close) { |event| finalize(event) }
    end

    def handle_message(data)
      data = JSON.parse(data)
      return unless data['message_type'] == 'certificate_update'

      cert = data['data']['leaf_cert']
      matching_names = DomainCache.fetch(cert['all_domains'])
      return unless matching_names.any?

      Canari.logger.info "Certificate matching #{matching_names}"
      Notifier.notify(matching_names, data)
    end
  end
end
