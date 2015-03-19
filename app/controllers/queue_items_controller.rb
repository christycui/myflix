class QueueItemsController < ApplicationController
  before_action :require_user
  def index
    @queue_items = current_user.queue_items
  end
  
  def create
    video = Video.find(params[:video_id])
    if !video_already_in_my_queue?(video)
      QueueItem.create(user: current_user, video: video, position: new_queue_item_position)
      flash[:notice] = "The video is added to your queue!"
    else
      flash[:error] = "The video is already in your queue."
    end
    redirect_to my_queue_path
  end
  
  def destroy
    queue_item = QueueItem.find(params[:id])
    queue_item.destroy if queue_item.user == current_user
    position = 1
    current_user.queue_items.each do |queue_item|
      queue_item.update(position: position)
      position += 1
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