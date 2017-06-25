class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def index

    @post = Post.new

    require 'twitter'

    client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV['CONSUMER_KEY'];
        config.consumer_secret     = ENV['CONSUMER_SECRET'];
        config.access_token        = ENV['ACCESS_TOKEN'];
        config.access_token_secret = ENV['ACCESS_TOKEN_SECRET'];
    end

    #取得数
    limit = 10

    #検索するハッシュタグの
    tag = "さ厳言"

    client.search("#{tag}", lang: 'ja', result_type: 'recent', count: 1).take(limit).each do |tweet|
      #投稿者名
      @post[:name] = tweet.user.name

      #投稿内容
      @post[:content] = tweet.text
    end
    @post.save

    @posts = Post.all

    render html:@posts


    end
end
