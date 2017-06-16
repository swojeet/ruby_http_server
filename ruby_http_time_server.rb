require 'benchmark'
require 'thread'
require 'socket'

server = TCPServer.new 5678
POOL_SIZE = 1000

jobs = Queue.new

workers = (POOL_SIZE).times.map do
  Thread.new do
    begin
      while session = server.accept
        jobs << session
        # request = session.gets
        # puts request

        while x = jobs.pop(true)
          session.print "HTTP/1.1 200\r\n"
          session.print "Content-Type: text/html\r\n"
          session.print "\r\n"
          session.puts "Hey there! Time is #{Time.now}"
          session.close
        end
      end
    rescue ThreadError
    end
  end
end
# workers.abort_on_exception=false

workers.map(&:join)
