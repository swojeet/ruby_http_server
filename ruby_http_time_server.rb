require 'benchmark'
require 'thread'
require 'socket'

server = TCPServer.new 5678
POOL_SIZE = 10

jobs = Queue.new

# 10_000.times {|i| jobs.push i}

# puts Benchmark.measure{
#   while session=server.accept
#     workers = (POOL_SIZE).times.map do
#       Thread.new do
#         begin
#           while x = session.pop(true)
#             session.puts "Time is #{Time.now.to_f * 1000} #{count}"
#           end
#         rescue
#           ThreadError
#         end
#       end
#     end
#     workers.map(&:join)
#     session.close
#   end
# }

workers = (POOL_SIZE).times.map do
  begin
    while session = server.accept
      jobs.push(session)
      puts jobs.inspect
      # p jobs
      # request = session.gets
      # puts request

      Thread.new do
        while x = jobs.pop(true)
          session.print "HTTP/1.1 200\r\n"
          session.print "Content-Type: text/html\r\n"
          session.print "\r\n"
          session.puts "Eh yo! Time is #{Time.now}"
          session.close
        end
      end
    end
  rescue
    ThreadError
  end
end

workers.map(&:join)
  # session.print "HTTP/1.1 200\r\n"
  # session.print "Content-Type: text/html\r\n"
  # session.print "\r\n"
  # session.puts "Eh yo! Time is #{Time.now}"
  #
  # session.close
