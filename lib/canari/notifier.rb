# frozen_string_literal: true

require 'mail'

module Canari
  # Send email notifications.
  module Notifier
    class << self
      def notify(matching, payload)
        Mail.new do
          from Canari.config[:notifier][:from]
          to Canari.config[:notifier][:to]
          subject 'New match in the Certificate Transparency Log network'
          body 'A new certificate has been emitted matching: ' \
               "#{matching.join(', ')}. See the attached file for details."
          add_file filename: 'certificate.json',
                   content: JSON.pretty_print(payload)
        end.deliver
      end
    end
  end
end
