class AdminsController < ApplicationController
  before_action :ensure_admin

  def ensure_admin
    flash[:error] = "You don't have access to that."
    redirect_to root_path unless logged_in? && current_user.admin?
  end
end