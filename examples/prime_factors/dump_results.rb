require '../../lib/queue_results.rb'
require './factor_class.rb'
que = QueuED::QueueResults.new(queue: "factors_example")
loop do
  temp = que.pop
  if !temp
    puts "Results queue is empty (we pop'd out all the values.) Sleeping for a bit..."
    sleep 10
  else
  puts "#{temp.get_factor} has a factorization of #{temp.result}"
  end
end

