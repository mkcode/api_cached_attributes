require 'api_cached_attributes/bridge'
require 'api_cached_attributes/dsl'
require 'api_cached_attributes/errors'
require 'api_cached_attributes/lookup_method_registration'
require 'api_cached_attributes/storage_registration'
require 'api_cached_attributes/subclass_registration'
require 'api_cached_attributes/version'
require 'active_support/core_ext/string'

# doc
module ApiCachedAttributes
  extend SubclassRegistration
  extend Configuration::Storage
  extend Configuration::LookupMethod

  # the base class for defining an api.
  class Base
    extend ApiCachedAttributes::DSL

    def self.inherited(subclass)
      ApiCachedAttributes.register_attributes_class(subclass)
    end

    def self.underscore
      name.underscore
    end
  end
end
