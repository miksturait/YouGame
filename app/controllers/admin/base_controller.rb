class Admin::BaseController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_tracker_member
  before_filter :require_admin_privilege

  private
  def require_admin_privilege
    redirect_to my_screen_path unless current_user.tracker_member.admin?
  end
end
