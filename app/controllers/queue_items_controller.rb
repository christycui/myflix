class QueueItemsController < ApplicationController
  before_action :require_user
  def index
    @queue_items = current_user.queue_items
  end
  
  def create
    video = Video.find(params[:video_id])
    queue_item = QueueItem.new(user: current_user, video: video, position: new_queue_item_position)
    if !video_already_in_my_queue?(video)
      QueueItem.create(user: current_user, video: video, position: new_queue_item_position)
      flash[:notice] = "The video is added to your queue!"
    else
      flash[:error] = "The video is already in your queue."
    end
    redirect_to my_queue_path
  end
  
  private
  
  def new_queue_item_position
    current_user.queue_items.count + 1
  end
  
  def video_already_in_my_queue?(video)
    current_user.queue_items.map(&:video).include?(video)
  end
end