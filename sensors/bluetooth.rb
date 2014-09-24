# encoding: utf-8

if RUBY_VERSION =~ /1.9/
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end

require 'sequel'
require 'open3'

module Sensors
  class Bluetooth

    attr_accessor :scanning, :db

    def initialize

    end

    def txpower(bdaddr, max_failed = 5, min_succeed = 10)
      cmd = "hcitool cc #{bdaddr} & hcitool tpl #{bdaddr}"

    end

    def rssi(bdaddr, max_failed = 100, min_succeed = 10)
      cmd = "hcitool cc #{bdaddr} & hcitool rssi #{bdaddr}"
      failed = 0
      succeed = 0
      rssis = []
      rssi_regex = /RSSI return value: (?<rssi>-?\d+)/
      while (failed < max_failed && succeed <= min_succeed) do
        stdin, stdout, stderr = Open3.popen3(cmd)
        results = stdout.read
        errors = stderr.read
        results = results.match(rssi_regex)

        if results
          rssis.push results[:rssi].to_f
          succeed += 1
        elsif errors && errors.include?('Read RSSI failed: Input/output error') && (results.nil? || results.length == 0)
          failed += 1
        else
          failed += 1
        end
      end
      puts rssis.inspect
      return nil if rssis.empty?
      return rssis.reduce(:+).to_f / rssis.size
    end

    def scan
      bdaddr_regex = /(?<bdaddr>[0-9A-Fa-f]{2}:[0-9A-Fa-f]{2}:[0-9A-Fa-f]{2}:[0-9A-Fa-f]{2}:[0-9A-Fa-f]{2}:[0-9A-Fa-f]{2})\s(?<description>.+)/
      @db = ::Sequel.sqlite('../soc_client.db')
      db_bluetooth_device = @db[:bluetooth_devices]
      @scanning = true
      while @scanning do
        stdin, stdout, stderr = Open3.popen3('hcitool scan --flush')
        results = stdout.read
        results = results.gsub(/\u2019/, '\'')
        bdaddrs = results.to_enum(:scan, bdaddr_regex).map { Regexp.last_match }
        bdaddrs.each do |bdaddr_set|
          bdaddr = bdaddr_set['bdaddr']
          description = bdaddr_set['description']
          if bdaddr
            existing_device = db_bluetooth_device.first('bdaddr = ?', bdaddr)
            if existing_device
              if description && existing_device[:description] != description
                puts "Update device #{bdaddr} => [#{existing_device[:description]}] [#{description}]"
                db_bluetooth_device.where('bdaddr = ?', bdaddr).update(description: description)
              end
            else
              puts "Found new device #{bdaddr} => #{description}"
              db_bluetooth_device.insert(bdaddr: bdaddr, description: description)
            end
          end
        end
      end
      @db.disconnect
    end

    def stop_scanning
      @scanning = false
    end

  end
end
