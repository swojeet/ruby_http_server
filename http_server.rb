require 'socket'
require 'rack'
require 'rack/lobster'
# require 'sinatra'

# app = Proc.new do
#   ['200',{'Content_Type' => 'text/html'},["Hello world! The time is #{Time.now}"]]
# end

app = Rack::Lobster.new
server = TCPServer.new 5678

while session = server.accept
    request = session.gets
    puts request

    method, full_path = request.split(' ')

    path, query = full_path.split('?')

    status, headers, body = app.call({
        'REQUEST_METHOD' => method,
        'PATH_INFO' => path,
        'QUERY_STRING' => query
    })

    # status, headers, body = app.call({})

    session.print "HTTP/1.1 #{status}\r\n"

    headers.each do |key, value|
      session.print "#{key}: #{value}\r\n"
    end

    session.print "\r\n"

    body.each do |part|
      session.print part
    end
    session.close
end
