class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  
  # GET /posts
  # GET /posts.json

  # def index
  #   @posts = Post.all
  # end


  def index
    require 'twitter'

    client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV['CONSUMER_KEY'];
        config.consumer_secret     = ENV['CONSUMER_SECRET'];
        config.access_token        = ENV['ACCESS_TOKEN'];
        config.access_token_secret = ENV['ACCESS_TOKEN_SECRET'];
    end

    #取得数
    limit = 5

    #検索するハッシュタグの
    tag = "#獣神祭で欲しいキャラ"

    if Post.last.nil? == false
      recent_post = Post.first[:created_time]
    end

    tweets = Array.new
    client.search("#{tag}", lang: 'ja', result_type: 'recent', count: 1).take(limit).map do |tweet|
      @post = Post.new

      #投稿者名
      @post[:name] = tweet.user.name

      #投稿内容
      @post[:content] = tweet.text

      # 投稿日時
      @post[:created_time] = tweet.created_at

      tweets << @post
    end

    unless recent_post.nil? then
      tweets.reverse.each do |i|
        if recent_post < i[:created_time]
          i.save
        end
      end
    else
      tweets.reverse.each do |i|
        i.save
      end
    end

    @posts = Post.all
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:name, :content)
    end
end
