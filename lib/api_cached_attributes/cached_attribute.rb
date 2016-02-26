require_relative './attribute_key'

module ApiCachedAttributes
  class ScopeNotSet < StandardError; end

  # Yes
  class CachedAttribute
    attr_reader :name, :base_class
    attr_accessor :client_scope

    def initialize(name, base_class)
      @name = name
      @base_class = base_class
      @client_scope = false
    end
    alias_method :method, :name

    def resource_name
      @base_class.cached_attributes[@name]
    end

    # nil is a possible valid value for @client_scope when there is no scope
    def client_scope?
      @client_scope != false
    end

    def client
      fail ScopeNotSet if @client_scope == false
      @base_class.client_proc.call(client_scope)
    end

    def resource(override_client = nil)
      if resource = @base_class.resources[resource_name]
        resource.call(override_client || client)
      else
        fail ArgumentError.new("there is no resource named #{name} on #{@name}.")
      end
    end

    def key
      return nil if @client_scope == false
      @key ||= AttributeKey.new(@base_class.underscore, resource_name,
                                @client_scope, @name)
    end
  end
end
