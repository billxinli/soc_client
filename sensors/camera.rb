module Sensors
  class Camera
    attr_accessor :path

    def initialize
      time = Time.now.strftime('%Y%m%d%H%M%S%L')
      @filename = "rpi_#{time}.jpg"
    end

    def capture(mode = :day)
      settings = ''
      if mode == :night
        settings = '-ISO 1600 -ss 500000'
      end

      cmd = "raspistill -w 960 -h 720 #{settings} --output #{@filename}"
      system(cmd)
    end

    def to_abs_path
      File.join(Dir.pwd, @filename)
    end

    def cleanup
      File.unlink(@filename)
    end
  end
end
