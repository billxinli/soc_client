require_relative './lib/ascp/constants'
require 'serialport'

module Services
  class Sign
    include Services::ASCP::Constants
    attr_accessor :type_code
    attr_accessor :sign_address

    def initialize(serial_port = '/dev/ttyUSB0', custom_modem_params = {})
      @type_code = 'ALL_SIGN'
      @sign_address = 'BROADCAST'
      @serial_port = serial_port
      modem_params = {
        'baud' => 9600,
        'data_bits' => 7,
        'stop_bits' => 2,
        'parity' => SerialPort::EVEN
      }
      modem_params = modem_params.merge(custom_modem_params).select { |k, v| ['baud', 'data_bits', 'stop_bits', 'parity'].include?(k) }
      @serial_port = SerialPort.new(@serial_port, modem_params)
    end

    def sign_address
      @sign_address
    end

    def sign_address=(str)
      raise ArgumentError, "'#{str}' is not a valid sign address" unless SIGN_ADDRESS[str]
      @sign_address = str
    end

    def type_code
      @type_code
    end

    def type_code=(str)
      raise ArgumentError, "'#{str}' is not a valid type code" unless TYPE_CODE[str]
      @type_code = str
    end

    def message_header
      "#{NULLS}#{SOH}#{TYPE_CODE[@type_code]}#{SIGN_ADDRESS[@sign_address]}#{STX}"
    end

    def message_footer
      "#{EOT}"
    end

    def simple_string(string='simple string')
      message = message_header
      message << COMMAND_CODE['WRITE_TEXT_FILE']
      message << "A"
      message << "\x1B"
      message << " b"
      message << string
      message << message_footer
      message
    end

    def simple_string!(string='simple string')
      message = simple_string(string)
      @serial_port.write_nonblock message
      @serial_port.close

    end

    def hello_world
      simple_string('hello world!')
    end

    def hello_world!
      message = hello_world
      @serial_port.write_nonblock message
      @serial_port.close
    end
  end
end