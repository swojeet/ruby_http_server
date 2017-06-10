require 'benchmark'
require 'thread'

POOL_SIZE = 5

count = 0

jobs = Queue.new

10_000.times {|i| jobs.push i}

puts Benchmark.measure{
  workers = (POOL_SIZE).times.map do
    Thread.new do
      begin
        while x = jobs.pop(true)
          count += 1
          puts "Time is #{Time.now.to_f * 1000} #{count}"
        end
      rescue
        ThreadError
      end
    end
  end
  puts "-----------------------"
  workers.map(&:join)
}
