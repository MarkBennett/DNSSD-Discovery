# Start a webserver and register it using DNS Service Discovery
require 'rubygems'

gem 'dnssd', '0.7.1'
require 'dnssd'
require 'webrick'

web_s = WEBrick::HTTPServer.new(:Port=>12345, :DocumentRoot=>Dir::pwd)
dns_s = DNSSD.register("My Files", "_http._tcp.", nil, 12345) do |r|
  warn("successfully registered: #{r.inspect}")
end

trap("INT"){ dns_s.stop; web_s.shutdown }
web_s.start
