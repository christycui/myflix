class VideosController < ApplicationController
  before_action :require_user

  def index
    @categories = Category.all
  end
  
  def show
    @video = Video.find(params[:id]).decorate
    @reviews = @video.reviews
    @review = Review.new
  end
  
  def search
    @results = Video.search_by_title(params[:search_str])
  end

  def advanced_search
    if params[:query]
      @videos = Video.search(params[:query]).records.to_a
    else
      @videos = []
    end
  end
end