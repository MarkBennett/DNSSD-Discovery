require 'rubygems'
gem 'dnssd', '0.7.1'
require 'dnssd'
require 'timeout'

s = DNSSD.browse('_http._tcp') do |browse_reply|
  if (DNSSD::Flags::Add & browse_reply.flags.to_i) != 0
    # We now need to resolve the service to get it's full details
    begin
      Timeout::timeout(2) do
        DNSSD::resolve!(browse_reply.name, browse_reply.type, browse_reply.domain) do |resolve_reply|
          puts "FOUND: #{resolve_reply.inspect}\n\ttext=#{resolve_reply.text_record.inspect}"
        end
      end
    rescue Timeout::Error
    end
  else
    puts "REMOVING: #{browse_reply.inspect}"
  end
end

puts "Scanning for services..."
while true
end
