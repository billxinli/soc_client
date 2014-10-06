module Services
  module ASCP
    module Constants
      NULLS = "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"
      SOH = "\1"
      STX = "\2"
      ETX = "\3"
      EOT = "\4"

      TYPE_CODE = {
        'ALL_SIGN' => 'Z'
      }.freeze

      SIGN_ADDRESS = {
        'BROADCAST' => '00'
      }.freeze

      COMMAND_CODE = {
        'WRITE_TEXT_FILE' => "A",
        'READ_TEXT_FILE' => "B",
        'WRITE_SPECIAL_FN' => "E",
        'READ_SPECIAL_FN' => "F",
        'WRITE_STRING_FILE' => "G",
        'READ_STRING_FILE' => "H",
        'WRITE_SMALL_DOTS_PICTURE_FILE' => "I",
        'READ_SMALL_DOTS_PICTURE_FILE' => "J",
        'WRITE_RGB_DOTS_PICTURE_FILE' => "K",
        'READ_RGB_DOTS_PICTURE_FILE' => "L",
        'WRITE_LARGE_DOTS_PICTURE_FILE' => "M",
        'READ_LARGE_DOTS_PICTURE_FILE' => "N",
        'WRITE_ALPHAVISION_BULLETIN_MESSAGE' => "O",
        'SET_TIME_OUT_MESSAGE' => "T"
      }.freeze
    end
  end
end