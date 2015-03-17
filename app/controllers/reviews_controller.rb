class ReviewsController < ApplicationController
  before_action :require_user
  before_action :sanitize_params
  def create
    @video = Video.find(params[:video_id])
    @review = @video.reviews.build(params.require(:review).permit(:rating, :body))
    @review.user = current_user
    if @review.save
      flash[:notice] = "Review added!"
      redirect_to @video
    else
      @reviews = @video.reviews.reload
      render "videos/show"
    end
  end
  
  private
  def sanitize_params
    params[:review][:rating] = params[:review][:rating].to_i
  end
end