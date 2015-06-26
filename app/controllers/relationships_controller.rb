class RelationshipsController < ApplicationController
  before_action :require_user
  def index
    @following = Relationship.where(follower_id: current_user.id)
  end
  
  def create
  end
  
  def destroy
    relationship = Relationship.find params[:id]
    relationship.destroy
    redirect_to relationships_path
  end
  
end