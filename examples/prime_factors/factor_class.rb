require_relative '../../lib/queue_class.rb'
require 'prime'
class Factor_Example < QueuED::QueueAble
  def initiailize
  end
  def get_random_factor
    @factor = Random.rand(100000..100000000) # Number is freaking huge so it takes long to factor
  end
  def get_factor
    @factor
  end

  def do_task
    @result = @factor.prime_division
  end

  def result
    @result
  end

end

