require_relative './test_class.rb'
require 'test/unit'
require 'redis'
require_relative '../lib/queue_worker.rb'
class VerySimpleTest < Test::Unit::TestCase
  def setup
    @queue = "test_queue"
    @a_bunch = "test_a_bunch"
    @redis = Redis.new
    @test_obj = Foo.new
    @test_obj.set_x(10)
    @test_obj.queue_up(redis: @redis, queue: @queue)
    @worker = QueuED::QueueWorker.new(redis: @redis, queue: @queue)
    @new_obj = @worker.work_once
    @results = []
    ##
    # Yes, the setup for fuzz testing here is sort of ugly
    100.times{ @results << Foo.new}
    @fuzzy_array = []
    100.times{@fuzzy_array << Foo.new}
    @fuzzy_array.map{|x| x.set_x(Random.rand(100))}
    @fuzzy_array.map{|x| x.queue_up(queue: @a_bunch, redis: @redis)}
  end

  def test_a_bunch
    worker = QueuED::QueueWorker.new(redis: @redis, queue:@a_bunch)
    worker.fire_and_forget
    @results.each_with_index do |x, i|
      json = @redis.rpop((@a_bunch + "_result"))
      if json
        x.from_hash!(JSON.parse(json))
      else
        @results[i] = nil
      end
    end
    puts @results.inspect
    @results.each do |res|
      assert_equal((res ? res.get_result : nil), (res ? res.do_calc : nil))
    end

  end
  def test_once
    assert_equal(@test_obj.do_calc,@new_obj.get_result)
  end
end

