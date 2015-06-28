class RelationshipsController < ApplicationController
  before_action :require_user
  def index
  end
  
  def create
  end
  
  def destroy
    relationship = Relationship.find params[:id]
    relationship.destroy if relationship.follower == current_user
    redirect_to people_path
  end
  
end