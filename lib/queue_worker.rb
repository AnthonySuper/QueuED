require 'redis'
require 'json'
require_relative './queue_class.rb'
require_relative './queued_constants.rb'
module QueuED
  class QueueWorker
    def initialize(opts = {})
      if opts[:redis] then
        raise ArgumentError.new("That's no Redis!") unless opts[:redis].is_a? Redis
        @redis = opts[:redis]
      else
        @redis = Redis.new
      end
      @queue = opts[:queue] ? opts[:queue] : "QueED"
    end
    ##
    # Gets the current head of the queue you specified when you created this worker
    # Does work
    # Returns the worked-on object, and adds that object into the results queue.
    def work_once()
      json = @redis.rpop @queue
      raise @@EOQ unless json
      hash = JSON.parse(json)
      # Next bit is sort of ugly, 
      klass = Object.const_get(hash["class"])
      raise ArgumentError.new("Improper Class") unless klass < QueuED::QueueAble
      obj = klass.new
      obj.from_hash!(hash)
      obj.do_task
      obj.queue_down(redis:@redis, queue:@queue)
      return obj
    end
    @@EOQ = Class.new(StandardError)
    ## 
    # Loops around forever, constantly doing work.
    def fire_and_forget(opts = {})
      interval = opts[:interval].is_a?(Fixnum) ? opts[:interval] : nil
      loop do
        begin
          self.work_once
        rescue @@EOQ => e
          break
        end
        sleep(interval) if interval
      end
    end
    ##
    # Just does "fire_and_forget" in a seperate thread.
    def fire_and_forget_threaded(opts = {})
      Thread.new { self.fire_and_forget(opts) }
    end
  end
end

