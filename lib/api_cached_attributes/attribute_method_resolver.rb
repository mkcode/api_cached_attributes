require_relative './cache_client'
require_relative './cache_control'
require_relative './cached_attribute'
require_relative './attribute_http_client'

module ApiCachedAttributes
  # Our humble lookup service
  class AttributeMethodResolver
    attr_reader :key_prefix, :attributes
    attr_accessor :db_cache

    def initialize(base_class, options)
      @base_class = base_class
      @options = options
      @db_cache = nil
      @attributes = create_cached_attributes!
    end

    def attribute(name)
      @attributes.detect { |attr| attr.name == name }
    end

    def create_cached_attributes!
      @base_class.cached_attributes.map do |method, value|
        CachedAttribute.new(method, @base_class)
      end
    end

    def get(method, scope, named_resource = :default, target_instance)
      key = key_for(method, scope, named_resource)

      attr = attribute(method)
      attr.client_scope = scope
      #
      # store = CacheStorage.new
      # stored = store.lookup_attribute(attr)
      # request_headers = stored.request_headers

      attr_client = AttributeHttpClient.new(attr)
      response_headers = attr_client.headers_only(request_headers)

      # if response_headers.status == 304
      #   store.write_attribute(stored_attr)
      #   return stored
      # else if response_headers.status == 200
      #   response = attr_client.get
      #   store.write_attribute(stored_attr)
      #   return stored
      # else
      #   Error: What do we do for errors here???
      # end
      #
      # remote_attr = RemoteAttribute.new(attr)
      # if remote_attr

      # moc = MethodOverideClient.new( client )
      # response_headers = moc.headers_only( resources[:default] )
      # cache_resolver = ResponseCache.new( response_headers )



      # @evaluator.client_scope = scope
      # @db_cache.target_instance = target_instance

      # cache_client = CacheClient.new(@evaluator.client)
      # headers = cache_client.headers(@base_class.resources[:default])
      # cache_control = CacheControl.new(headers['cache-control'])

      # moc = MethodOverideClient.new( client )
      # response_headers = moc.headers_only( resources[:default] )
      # cache_resolver = ResponseCache.new( response_headers )
      #   => resources[:default]


      # AttributeLookupService

      unless false # cache_control.private?
        # return redis_value if @REDIS.read_key(key)
        db_value = @db_cache.read_key(key)
        if db_value
          puts 'DB HIT'
          return db_value
        end
        puts 'DB MISS'
      end

      # resource = @evaluator.resource(named_resource)
      value = resource.send(method.to_sym)
      @db_cache.write_key(key, value)
      value
    end

    def key_prefix
      @base_class.underscore
    end

    def key_for(method, scope, named_resource = :default)
      scope_part = scope.map{ |k,v| "#{k}=#{v}" }.join('&')
      # "#{@key_prefix}/#{scope_part}/#{named_resource}/#{method}"
      [key_prefix, scope_part, named_resource, method].join('/')
    end
  end
end
