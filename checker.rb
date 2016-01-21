#!/usr/bin/ruby
#encoding: utf-8
require 'time'
require 'twitter'


inputname = "INPUT_FILE_NAME"

#OAuth information
API_KEY = "YOUR_API_KEY"
API_SECRET = "YOUR_API_SECRET"
ACCESS_TOKEN = "YOUR_ACCESS_TOKEN"
ACCESS_TOKEN_SECRET = "YOUR_ACCESS_TOKEN_SECRET"

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = API_KEY
  config.consumer_secret     = API_SECRET
  config.access_token        = ACCESS_TOKEN
  config.access_token_secret = ACCESS_TOKEN_SECRET
end

logfile = File::open("history.log", "r")
d = logfile.readlines[-1].chomp.split(',')
t_init = Time::now
t_hour_old = t_init.hour
fsize_old = d[-1].to_i
logfile.close()

puts "#{t_init}: #{fsize_old}"
sleep(3595 - t_init.min * 60 - t_init.sec)

loop do

    t = Time::now

    if t.hour != t_hour_old
    
        logfile = File::open(logfname, "a+")
        fsize = File.size(inputname)
        if fsize > fsize_old
            puts "#{t}: #{fsize} bytes (+ #{fsize-fsize_old})"
            client.update("#{t}: #{fsize} bytes (+ #{fsize-fsize_old})")
        elsif fsize < fsize_old
            puts "#{t}: #{fsize} bytes (- #{fsize_old-fsize})"
            client.update("#{t}: #{fsize} bytes (- #{fsize_old-fsize})")
        else
            puts "#{t}: #{fsize} bytes (no change)"
            client.update("#{fsize} bytes(No progress)")
        end
        logfile.puts "#{t.to_s}, #{fsize}"
        logfile.close()
        
        fsize_old = fsize
        t_hour_old = t.hour
        
        sleep(3595 - Time::now.sec)
    end
    
    sleep(0.5)
    
end