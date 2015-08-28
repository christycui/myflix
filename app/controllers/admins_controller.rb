class AdminsController < ApplicationController
  before_action :require_user
  before_action :ensure_admin

  def ensure_admin
    if !current_user.admin?
      flash[:error] = "You don't have access to that."
      redirect_to root_path
    end
  end
end