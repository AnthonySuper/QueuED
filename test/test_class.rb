require_relative '../lib/queue_class.rb'
class Foo < QueuED::QueueAble
  def initialize
  end
  def set_x(x)
    @x = x
  end
  def do_calc
    @x ** 2 / 4
  end

  def do_task
    @result = self.do_calc
  end
  def get_result
    @result
  end

end

