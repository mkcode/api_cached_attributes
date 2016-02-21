require 'api_cached_attributes/version'
require 'api_cached_attributes/db_cache'
require 'active_support/concern'

module ApiCachedAttributes
  module Base
    extend ActiveSupport::Concern

    included do
      extend ClassMethods
    end

    # class NoClientError < StandardError; end;

    module ClassMethods

      def api_cached_attributes(client: :api_cached_attributes_client, column: :api_cached_attributes_cache,
                         request_key: :defail)
        @client = client if ensure_symbol_or_proc(client)
        @__api_cached_attributes_db_cache ||= {}
        # @__api_cached_attributes_db_cache[request_key]  = ApiCachedAttributes::DBCache.new(self, column)
      end

      def api_attr(method_symbol, request_key = :default, &block)
        define_method method_symbol do
          @__api_cached_attributes_db_cache[request_key].read(request_key)
          instance_exec { block.call() }
        end
      end

      private

      def ensure_symbol_or_proc(thing)
        return true if thing.is_a? Symbol || thing.respond_to?(:call)
        raise ArgumentError.new 'client must be a symbol or proc'
      end
    end
  end
end
