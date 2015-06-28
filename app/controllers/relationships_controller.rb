class RelationshipsController < ApplicationController
  before_action :require_user
  def index
  end
  
  def create
    user = User.find params[:user_id]
    Relationship.create(user: user, follower: current_user) unless current_user.follows?(user) || user == current_user
    redirect_to user_path(user)
  end
  
  def destroy
    relationship = Relationship.find params[:id]
    relationship.destroy if relationship.follower == current_user
    redirect_to people_path
  end
  
end