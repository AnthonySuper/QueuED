##
# You can run this in multiple processes, to find factors in parallel.
#
# Heck, with some tweaking, you can run this on hundreds of machines.
# Of course, if you really need that kind of speed, you should be using C or C++, not Ruby
#
require_relative '../../lib/queue_worker.rb'
require_relative './factor_class.rb'
w = QueuED::QueueWorker.new(queue:"factors_example")
w.fire_and_forget
