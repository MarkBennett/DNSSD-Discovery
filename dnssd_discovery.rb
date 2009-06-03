require 'rubygems'
gem 'dnssd', '0.7.1'
require 'dnssd'

# Browse the network for web servers (_http._tcp services)
puts "Scanning network for web servers"
service = DNSSD.browse('_http._tcp.') do |reply|
  if (reply.flags == DNSSD::Flags::Add)
    puts "adding: #{reply.inspect}"

    # Let's lookup the details
    resolver_service = DNSSD.resolve(reply.name, reply.type, reply.domain) do |resolved|
      puts "\tdomain = #{resolved.domain}"
      puts "\tflags = #{resolved.flags.inspect}"
      puts "\tfullname = #{resolved.fullname}"
      puts "\tinterface = #{resolved.interface}"
      puts "\tname = #{resolved.name}"
      puts "\tport = #{resolved.port}"
      puts "\tservice = #{resolved.service}"
      puts "\ttarget = #{resolved.target}"
      puts "\ttext_record = #{resolved.text_record.inspect}"
      puts "\ttype = #{resolved.type}"
    end
    sleep(2)
    resolver_service.stop
  else
      puts "removing: #{reply.inspect}"
  end
end

# Catch the interrupt signal
interrupted = false
Signal.trap("INT") do
  interrupted = true
end

# Run until the application is interrupted
loop do
  if interrupted
    puts "Halting network scan"
    service.stop
    exit
  end
end
