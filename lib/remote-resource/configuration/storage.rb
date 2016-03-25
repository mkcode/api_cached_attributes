require 'api_cached_attributes/storage/memory'

module ApiCachedAttributes
  module Configuration
    # Our humble storage
    module Storage
      def self.extended(klass)
        klass.instance_variable_set(:@storages, nil)
      end

      def storages=(storages)
        @storages = storages
      end

      def storages
        @storages ||= default_storages
      end

      def default_storages
        [ApiCachedAttributes::Storage::Memory.new]
      end
    end
  end
end
