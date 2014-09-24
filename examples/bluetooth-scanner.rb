#!/usr/bin/env ruby

require_relative '../sensors/bluetooth'

puts 'Example loaded'

bluetooth = Sensors::Bluetooth.new

trap("SIGINT") {
  bluetooth.stop_scanning
}

puts 'Starting scanning bluetooth devices, ctrl-c to exit'
bluetooth.scan
puts 'Done'

