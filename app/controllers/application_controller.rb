class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def index
    require 'twitter'
  end
end
