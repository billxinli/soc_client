class Camera
  attr_accessor :path

  def initialize
    time = Time.now.strftime('%Y%m%d%H%M%S%L')
    @filename = "rpi_#{time}.jpg"
  end

  def capture
    cmd = "raspistill --nopreview --timeout 1 --thumb none --output #{@filename}"
    system(cmd)
  end

  def to_abs_path
    File.join(File.expand_path(File.dirname(__FILE__)), @filename)
  end

  def cleanup
    File.unlink(@filename)
  end
end