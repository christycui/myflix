class QueueItemsController < ApplicationController
  before_action :require_user
  def index
    @queue_items = current_user.queue_items
  end
  
  def create
    video = Video.find(params[:video_id])
    unless video_already_in_my_queue?(video)
      QueueItem.create(user: current_user, video: video, position: new_queue_item_position)
      flash[:notice] = "The video is added to your queue!"
    else
      flash[:error] = "The video is already in your queue."
    end
    redirect_to my_queue_path
  end
  
  def update_queue
    begin
      update_queue_items
      current_user.normalize_queue_items
    rescue ActiveRecord::RecordInvalid
      flash[:error] = "Please enter a valid input."
    end
    
    redirect_to my_queue_path
  end
  
  def destroy
    queue_item = QueueItem.find(params[:id])
    queue_item.destroy if queue_item.user == current_user
    current_user.normalize_queue_items
    redirect_to my_queue_path
  end
  
  private
  
  def new_queue_item_position
    current_user.queue_items.count + 1
  end
  
  def video_already_in_my_queue?(video)
    current_user.queue_items.map(&:video).include?(video)
  end
  
  def update_queue_items
    ActiveRecord::Base.transaction do
      params[:queue_items].each do |queue_item_data|
        queue_item = QueueItem.find(queue_item_data[:id])
        if queue_item.user == current_user
          queue_item.update_attributes!(position: queue_item_data[:position], rating: queue_item_data[:rating])
        end
      end
    end
  end
  
end