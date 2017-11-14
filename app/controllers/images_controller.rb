class ImagesController < ApplicationController
  before_action :set_image, only: [:show, :edit, :update, :destroy]

  # GET /images
  # GET /images.json
  def index

    require 'twitter'
    require 'open-uri'

    client = Twitter::REST::Client.new do |config|
        config.consumer_key        = "FclB5az1e0DWZ34a9MckEGvGD";
        config.consumer_secret     = "XNXRgFURS5iFh79uODnGGi7XPdawGPresfipVEKchHmomzHATj";
        config.access_token        = "733237416-5GwKOseWBtzBykr8sosVDkfEHzusPSIlhvBlhOcf";
        config.access_token_secret = "BNt00a1q1Kc8faBb4leHo8HRcl2vAukWxFF2YVr4LCVO1";
    end

    tag = "#ねこ部 -rt"
    # -rtをつけることでリツイートを除外

    count = 0
    flag = false

    limit = 15
    #
    all = Array.new
    usr_posts = Array.new
    post = Hash.new
    #
    usr_images = Array.new
    image = Hash.new

    # entities = Array.new

    client.search("#{tag}", lang: 'ja', result_type: 'recent', include_entities: 1).each do |tweet|
      flag2 = false
      tweet.media.each do |media|
        x = media.media_url.to_s
        if !(x.nil?) then
          y = open(x).read

          image = { url:x, data:y }
          # images << open("#{@image[:image_url]}").read

          flag2 = true
        end
      end

      if flag2 then
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

    #
    #


            # usr_images.each do |i|
            #   count = 0
            #   @image = Image.new
            #   i.each_value do |value|
            #     case count
            #     when 0 then
            #       @image[:image_url] = value
            #       count += 1
            #     when 1 then
            #       @image[:data] = value
            #       @image.save
            #     end
            #   end
            # end

            # tweet.each do |i|
            #   image = { :name => i.user.name, :cotent => i.text }
            #
            #   usr_images << image
            # end


            # post = { :name => tweet.user.name, :content => tweet.text }
            # usr_posts << post



            # usr_posts.zip(usr_images).each do |post, image|
            #   post.merge(image)
            #   all << post
            # end

            # all.each do |i|
            #   count = 0
            #   @image = Image.new
            #   i.each_value do |t|
            #     case count
            #     when 0 then
            #       @image[:name] = t
            #       count += 1
            #     when 1 then
            #       @image[:content] = t
            #       count += 1
            #     when 2 then
            #       @image[:url] = t
            #       count += 1
            #     when 3 then
            #       @image[:data] = t
            #       @image.save
            #     end
            #   end
            # end


        # client.search("#{tag}", lang: 'ja', result_type: 'recent', include_entities: 1).take(limit).each do |tweet|
        #   tweet.media.each do |media|
        #     if count < 100 then
        #       @image = Image.new
        #       @image[:image_url] = media.media_url.to_s
        #       @image[:data] = open("#{@image[:image_url]}").read
        #       @image.save
        #     else
        #       flag = true
        #       break
        #     end
        #     count += 1
        #   end
        #   break if flag
        # end


    # @images = Image.all
    # @images = Image.limit(40)
    @images = Image.page(params[:page])
    respond_to do |format|
     format.html # index.html.erb
     format.xml  { render :xml => @images }
    end
  end

  def get_image
    @image = Image.find(params[:id])
    send_data(@image.data, :disposition => "inline", :type => "image/png")
  end

  # GET /images/1
  # GET /images/1.json
  def show
  end

  # GET /images/new
  def new
    @image = Image.new
  end

  # GET /images/1/edit
  def edit
  end

  # POST /images
  # POST /images.json
  def create
    @image = Image.new(image_params)

    respond_to do |format|
      if @image.save
        format.html { redirect_to @image, notice: 'Image was successfully created.' }
        format.json { render :show, status: :created, location: @image }
      else
        format.html { render :new }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /images/1
  # PATCH/PUT /images/1.json
  def update
    respond_to do |format|
      if @image.update(image_params)
        format.html { redirect_to @image, notice: 'Image was successfully updated.' }
        format.json { render :show, status: :ok, location: @image }
      else
        format.html { render :edit }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    @image.destroy
    respond_to do |format|
      format.html { redirect_to images_url, notice: 'Image was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_image
      @image = Image.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def image_params
      params.require(:image).permit(:image_url, :data)
    end
end
