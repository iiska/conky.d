#! /usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'net/http'
require 'uri'
require 'rexml/document'
include REXML

tmpfile = "/tmp/willab.xml"

# Don't load server too much and use tmpfile if it's fresh enough
if File.exists?(tmpfile) && ( (Time.now - File.mtime(tmpfile)) < 60 )
  @doc = Document.new(File.new(tmpfile, "r").read)
else
  url = URI.parse('http://weather.willab.fi/weather.xml')
  http = Net::HTTP.new(url.host, url.port)
  req = Net::HTTP::Get.new(url.path)
  @doc = Document.new(http.request(req).body)
  File.new(tmpfile, "w").write(@doc)
end

weather = @doc.root.elements[1];

ARGV.each do |i|
  u = weather.elements[i].attribute("unit").value
  if (u=="degrees")
    u = "˚"
  elsif (u=="C")
    u = "˚" + u
  elsif (u!="%")
    u = " " + u
  end
  puts weather.elements[i].text + u
end
