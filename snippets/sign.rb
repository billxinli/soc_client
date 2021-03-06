#!/usr/bin/env ruby

require_relative './sign_data_source/sign_data_source'
require_relative './sign_data_source/ttc_data_source'
require_relative './sign_data_source/temperature_data_source'
require_relative './sign_data_source/date_time_data_source'
require_relative '../snippets/sign_data_source/morning_star_data_source'
require_relative '../services/sign'

mds = MorningStarDataSource.new
dtds = DateTimeDataSource.new
tds = TemperatureDataSource.new
ttcds = TtcDataSource.new

message = [
  dtds.get_data,
  tds.get_data,
  ttcds.get_data({ stopId: '10210', routeTag: '511' }),
  # ttcds.get_data({ stopId: '10773', routeTag: '509' }),
  mds.get_data
].compact.join('|')

if ARGV.first && ARGV.first == 'write-to-sign'
  ascp = Services::Sign.new('/dev/ttyUSB0')
  ascp.type_code = 'ALL_SIGN'
  ascp.sign_address = 'BROADCAST'
  ascp.simple_string!(message)
else
  puts message
end