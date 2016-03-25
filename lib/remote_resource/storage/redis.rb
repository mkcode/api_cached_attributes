require 'remote_resource/storage/serializers/marshal'
require 'remote_resource/storage/storage_entry'

module RemoteResource
  module Storage
    class Redis
      def initialize(redis, serializer = nil)
        @redis = redis
        @serializer = serializer || Serializers::MarshalSerializer.new
      end

      def read_key(key)
        redis_value = @redis.hgetall key
        StorageEntry.new @serializer.load(redis_value['headers']),
                         @serializer.load(redis_value['data'])
      end

      def write_key(storage_key, storage_entry)
        write_args = []
        storage_entry.to_hash.each_pair do |key, value|
          write_args.concat([key, @serializer.dump(value)]) unless value.empty?
        end
        @redis.hmset storage_key, *write_args
      end
    end
  end
end
