require_relative './attribute_storage_value'
require 'active_support/core_ext/hash/reverse_merge'

module ApiCachedAttributes
  # Attribute lookup class. Top most level class used for looking up attributes
  # across storages and remotely over http.
  #
  # Arguments:
  #   options:
  #     validate: 'cache_control', 'true', 'false' - Should values looked up
  #     in storage be validated with the server. The default value
  #     'cache_control', sets this according to the server returned
  #     Cache-Control header. Values true and false override this.
  class AttributeLookup
    def initialize(options = {})
      @options = options.reverse_merge({
        validate: :cache_control
      })
    end

    def find(attribute)
      store_value = AttributeStorageValue.new(attribute)
      if store_value.data?
        puts 'attr data exists'
        if should_validate?(store_value)
          puts 'attr data expired. updating...'
          store_value.validate
        end
      else
        puts 'attr data does not exist. fetching...'
        store_value.fetch
      end
      store_value
    end

    private

    def should_validate?(store_value)
      return @options[:validate] unless @options[:validate] == :cache_control
      store_value.validateable? && store_value.expired?
    end
  end
end
