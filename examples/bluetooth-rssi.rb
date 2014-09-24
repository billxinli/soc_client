#!/usr/bin/env ruby

require_relative '../sensors/bluetooth'

puts 'Example loaded'

bluetooth = Sensors::Bluetooth.new

puts "Note 3: #{bluetooth.rssi('c4:62:ea:c6:69:52')}"
puts "Xoom  : #{bluetooth.rssi('40:fc:89:90:8c:9e')}"