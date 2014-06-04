require 'redis'
require 'json'
require_relative './queue_class.rb'
require_relative './queued_constants.rb'
module QueuED
  class QueueResults
    def initialize(opts = {})
      @redis = opts[:redis] ? opts[:redis] : Redis.new
      @queue = opts[:queue] ? opts[:queue] : "QueuED"
      @queue << "_result"
    end

    def pop
      json = @redis.rpop(@queue)
      return nil unless json
      hash = JSON.parse(json)
      klass = Object.const_get(hash["class"])
      var = klass.new
      var.from_hash!(hash)
      return var
    end

  end
end

