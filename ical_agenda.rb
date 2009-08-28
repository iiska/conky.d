#!/usr/bin/env ruby
# Fetches multiple ical feeds and lists agenda to
# stdout. Designed to be used with Conky

require 'date'
require 'net/http'

require 'rubygems'
require 'icalendar'


# Add ical feeds here.
cal_urls = ["http://www.oty.fi/feed/?t=cal&f=ics"]

cal = Icalendar::Calendar.new
now = DateTime.now

cal_urls.each{|url|
  open("/tmp/ical_agenda-tmp","w") do |f|
    f.write Net::HTTP.get(URI.parse(url))
  end
  tmpcal = Icalendar.parse(File.open("/tmp/ical_agenda-tmp"))
  tmpcal.collect{|c| c.events.each{|e|
    if (e.start > now)
      cal.add_event(e)
    end
  }}
}

cal.events.sort_by{|e| e.start}[0,10].each{|e|
  if (e.start.strftime('%Y%m%d') == now.strftime('%Y%m%d'))
  	print "#{e.start.strftime('%H:%M')} - #{e.summary}\n"
  elsif (e.start.strftime('%Y%m%d') == (now+1).strftime('%Y%m%d'))
	print "Tomorrow #{e.start.strftime('%H:%M')} - #{e.summary}\n"
  else
	print "#{e.start.strftime('%d.%m %H:%M')} - #{e.summary}\n"
  end
}
