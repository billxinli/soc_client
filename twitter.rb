require 'twitter'

client = Twitter::REST::Client.new do |config|
  config.consumer_key = ENV['TWITTER_ACCESS_TOKEN']
  config.consumer_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
  config.access_token = ENV['TWITTER_API_KEY']
  config.access_token_secret = ENV['TWITTER_API_SECRET']
end

# client.update_with_media("I'm tweeting with gem!", File.new("/path/to/media.png"))
client.update_with_media("I'm tweeting with gem!")

