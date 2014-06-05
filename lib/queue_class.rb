require 'json'
require 'redis'
##
# Top-level module
module QueuED
  ##
  # The main class for QueuED. Any objects the user wants to include must subclass this.
  # NOTE: The class MUST have an initializer that takes no arguments for this to work.
  #
  class QueueAble
    ##
    # Serializes to a JSON, in order to properly store in Redis.
    def make_json
      hash = {}
      hash[:class] = self.class.to_s
      self.instance_variables.each do |var|
        hash[var] = self.instance_variable_get var
      end
      hash.to_json
    end
    def from_hash!(hash)
      hash.each do |var, val|
        self.instance_variable_set(var, val) unless var == "class"
      end
    end
    ## 
    # Add this object to a queue. Takes two possible arguments:
    # redis: REDIS, which specifies which Redis server to use
    # queue: QUEUE, which specifies which Queue to put it on
    def queue_up(opts = {})
      if opts[:redis] then
        raise ArgumentError.new("That's no redis!") unless opts[:redis].is_a? Redis 
        redis = opts[:redis]
      else
        redis = Redis.new
      end
      queue = opts[:queue] ? opts[:queue] : "QueED"
      redis.lpush queue, self.make_json
    end
    def queue_down(opts = {})
      # Yes, this was copypasta'd. I'll fix it in a better revision.
      if opts[:redis] then
        raise ArgumentError.new("That's no redis!") unless opts[:redis].is_a? Redis 
        redis = opts[:redis]
      else
        redis = Redis.new
      end
      queue = opts[:queue] ? opts[:queue] : "QueuED"
      self.do_task
      redis.lpush(queue+"_result", self.make_json)
    end
    def do_task
      raise NotImplimentedError
    end

  end

end

