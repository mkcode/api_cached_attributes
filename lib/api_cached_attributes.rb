require 'api_cached_attributes/bridge'
require 'api_cached_attributes/dsl'
require 'api_cached_attributes/errors'
require 'api_cached_attributes/configuration/lookup_method'
require 'api_cached_attributes/configuration/storage'
require 'api_cached_attributes/version'
require 'active_support/core_ext/string'
require 'active_support/descendants_tracker'

# doc
module ApiCachedAttributes
  extend Configuration::Storage
  extend Configuration::LookupMethod

  # the base class for defining an api.
  class Base
    extend ApiCachedAttributes::DSL
    extend ActiveSupport::DescendantsTracker

    def self.find_descendant(which_class)
      descendants.detect do |descendant|
        [descendant.underscore, descendant.underscore.sub('_attributes', '')]
          .include? which_class.to_s
      end
    end

    def self.underscore
      name.underscore
    end
  end
end
