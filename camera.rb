class Camera
  attr_accessor :path

  def initialize
    time = Time.now.strftime('%Y%m%d%H%M%S%L')
    @path = "rpi_#{time}.jpg"
  end

  def capture
    cmd = "raspistill --nopreview --timeout 1 --thumb none --output #{@path}"
    system(cmd)
  end

  def cleanup
    File.unlink(@path)
  end

end

camera = Camera.new
camera.capture
puts camera.path
`cp #{camera.path} out.jpg`
camera.cleanup
