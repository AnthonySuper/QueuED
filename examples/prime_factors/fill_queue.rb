require_relative './factor_class.rb'
def fill_queue(t)
  t.times do
    f = Factor_Example.new
    puts "Added number #{f.get_random_factor} to queue."
    f.queue_up(queue:"factors_example")
  end
end
puts "Filling queue with #{ARGV[0]} random numbers."
fill_queue ARGV[0].to_i
