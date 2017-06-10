require "benchmark"
require "celluloid"

class TimeServe
  include Celluloid

  def send_time
    puts "Time is #{Time.now}"
  end
end

time_pool = TimeServe.pool(size: 10)

10_000.times do |i|
  time_pool.async.send_time(i)
end
