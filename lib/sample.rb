class Sample
  require 'twitter'
  require 'open-uri'

  def self.get_tweet
    logger = Logger.new('log/development.log')
    logger.debug()

    client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV["CONSUMER_KEY"]
        config.consumer_secret     = ENV["CONSUMER_SECRET"]
        config.access_token        = ENV["ACCESS_TOKEN"]
        config.access_token_secret = ENV["ACCESS_TOKEN_SECRET"]
    end

    tag = "#神戸電子専門学校 -rt"

    # 何ツイート取得するか
    limit = 100

    image = Hash.new

    client.search("#{tag}", lang: 'ja', result_type: 'recent', include_entities: 1).take(limit).each do |tweet|
      flag = false
      tweet.media.each do |media|
        i = 0
        x = media.media_url.to_s
        # 画像のありなしの判断
        if !(x.nil?) then
          y = open(x).read

          image = { image_url:x, data:y }

          flag = true
        end
      end

      if flag then
        post = { name:tweet.user.name, content:tweet.text }
        post.merge!(image)
        @image = Image.new
        @image[:name] = post[:name]
        @image[:content] = post[:content]
        @image[:image_url] = post[:image_url]
        @image[:data] = post[:data]

        @image.save
      end
    end
  end
end
