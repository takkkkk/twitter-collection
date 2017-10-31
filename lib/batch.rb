
class Tasks::Batch
  require 'twitter'
  require 'open-uri'

  def self.execute
    # 実行したいコードを書く
    p "Hello world"
  end

  def self.get_tweet
    client = Twitter::REST::Client.new do |config|
        config.consumer_key        = "FclB5az1e0DWZ34a9MckEGvGD";
        config.consumer_secret     = "XNXRgFURS5iFh79uODnGGi7XPdawGPresfipVEKchHmomzHATj";
        config.access_token        = "733237416-5GwKOseWBtzBykr8sosVDkfEHzusPSIlhvBlhOcf";
        config.access_token_secret = "BNt00a1q1Kc8faBb4leHo8HRcl2vAukWxFF2YVr4LCVO1";
    end

    tag = "#ねこ部 -rt"

    image = Hash.new

    client.search("#{tag}", lang: 'ja', result_type: 'recent', include_entities: 1).each do |tweet|
      flag = false
      tweet.media.each do |media|
        i = 0
        x = media.media_url.to_s
        if !(x.nil?) then
          y = open(x).read

          image = { url:x, data:y }

          flag = true
        end
      end

      if flag then
        post = { name:tweet.user.name, content:tweet.text }
        post.merge!(image)
        @image = Image.new
        @image[:name] = post[:name]
        @image[:content] = post[:content]
        @image[:image_url] = post[:url]
        @image[:data] = post[:data]

        @image.save
      end
    end
  end
end
