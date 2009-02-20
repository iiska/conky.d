#! /usr/bin/env ruby

require 'net/http'
require 'uri'
require 'rexml/document'
include REXML

url = URI.parse('http://weather.willab.fi/weather.xml')
http = Net::HTTP.new(url.host, url.port)
req = Net::HTTP::Get.new(url.path)
doc = Document.new(http.request(req).body)

weather = doc.root.elements[1];

ARGV.each do |i|
  puts weather.elements[i].text + "˚" +
    weather.elements[i].attribute("unit").value
end
