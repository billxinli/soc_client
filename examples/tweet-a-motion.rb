require_relative '../sensors/camera'
require_relative '../services/twitter'

camera = Sensors::Camera.new
twitter = Services::Twitter.new

camera.capture
twitter.tweet_image('Just captured', camera.to_abs_path)
camera.cleanup