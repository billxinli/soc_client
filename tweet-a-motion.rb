require_relative 'sensors/camera'
require_relative 'sensors/motion'
require_relative 'services/twitter'

camera = Camera.new
twitter = Twitter.new

camera.capture
twitter.tweet_image('Just captured', camera.to_abs_path)
camera.cleanup