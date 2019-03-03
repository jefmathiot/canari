# frozen_string_literal: true

module Canari
  # Store and retrieve domains from Memcached
  class DomainCache
    class << self
      def preload(domains_file)
        cache.flush
        count = 0
        File.readlines(File.expand_path(domains_file)).each do |line|
          line = line.strip
          next if line.start_with?('#')

          cache.set(line, 1)
          count += 1
        end
        Canari.logger.info "Preloaded #{count} domains"
      end

      def fetch(domains)
        keys = variants(domains)
        cache.get_multi(keys).keys
      end

      def variants(domains)
        domains.map do |domain|
          domain = domain.split('.').reject { |part| part == '*' }.join('.')
          [domain].tap do |values|
            until domain.empty?
              domain = domain.split('.').drop(1).join('.')
              values << domain unless domain.empty?
            end
          end
        end.flatten.uniq
      end

      def cache
        return @cache if @cache

        mconfig = Canari.config[:memcached]
        @cache = Dalli::Client.new("#{mconfig[:host]}:#{mconfig[:port]}",
                                   namespace: mconfig[:namespace])
      end
    end
  end
end
